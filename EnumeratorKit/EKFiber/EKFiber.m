//
//  EKFiber.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 17/11/2015.
//  Copyright © 2015 Adam Sharp. All rights reserved.
//

#import "EKFiber.h"

#import <libmill.h>
#undef end

static void *kWait = &kWait;

@interface EKFiber (async)
- (void)async_execute;
@end

@interface EKFiber () <EKYielder>
@property (nonatomic, assign) chan ch;
@property (nonatomic, assign) chan wait;
@property (nonatomic, copy) void (^block)(id<EKYielder>);
@end

@implementation EKFiber

+ (instancetype)fiberWithBlock:(void (^)(id<EKYielder>))block
{
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(void (^)(id<EKYielder>))block
{
    if (self = [super init]) {
        _block = [block copy];
        _ch = chmake(id, 1);
        _wait = chmake(void *, 1);

        [self async_execute];
    }
    return self;
}

- (void)execute
{
    chr(_wait, void *);
    _block((id)self);
    chdone(_ch, id, nil);
}

- (id)resume
{
    chs(_wait, void *, kWait);
    return chr(_ch, __unsafe_unretained id);
}

- (void)yield:(id)obj
{
    chs(_ch, id, obj);
    chr(_wait, void *);
}

- (void)dealloc
{
    chdone(_wait, void *, NULL);
    chclose(_wait);
    chclose(_ch);
}

#pragma mark Async dispatch

static BOOL IsAsyncSelector(SEL aSelector) {
    return [NSStringFromSelector(aSelector) hasPrefix:@"async_"];
}

static SEL SelectorFromAsyncSelector(SEL aSelector) {
    return NSSelectorFromString([NSStringFromSelector(aSelector) stringByReplacingOccurrencesOfString:@"async_" withString:@""]);
}

static coroutine void invoke(id self, NSInvocation *anInvocation)
{
    [anInvocation invoke];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (IsAsyncSelector(aSelector)) {
        return [super respondsToSelector:SelectorFromAsyncSelector(aSelector)];
    } else {
        return [super respondsToSelector:aSelector];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (IsAsyncSelector(aSelector)) {
        return [super methodSignatureForSelector:SelectorFromAsyncSelector(aSelector)];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    anInvocation.selector = SelectorFromAsyncSelector(anInvocation.selector);
    go(invoke(self, anInvocation));
}

@end
