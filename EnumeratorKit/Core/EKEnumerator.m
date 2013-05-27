//
//  EKEnumerator.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "EKEnumerator.h"
#import "EKFiber.h"

@interface EKEnumerator ()

@property (nonatomic, copy) void (^block)(id);
@property (nonatomic, strong) EKFiber *fiber;

- (id)next:(BOOL)peek;
@property (nonatomic, strong) id lastPeek;

@end

@implementation EKEnumerator

+ (void)load
{
    [self includeEnumerable];
}

+ (instancetype)enumeratorWithObject:(id)object
{
    return [[EKEnumerator alloc] initWithObject:object];
}
- (id)initWithObject:(id)object
{
    if ([object respondsToSelector:@selector(each:)]) {
        self = [self initWithBlock:^(id<EKYielder> y) {
            [object each:^(id obj) {
                [y yield:obj];
            }];
        }];
    }
    else {
        self = [self initWithBlock:^(id<EKYielder> y) {
            [y yield:object];
        }];
    }
    return self;
}

+ (instancetype)enumeratorWithBlock:(void (^)(id<EKYielder> y))block
{
    return [[self alloc] initWithBlock:block];
}
- (id)initWithBlock:(void (^)(id<EKYielder> y))block
{
    if (self = [super init]) {
        _block = [block copy];
    }
    return self;
}

- (id)each:(void (^)(id))block
{
    EKFiber *fiber = [EKFiber fiberWithBlock:^id{
        self.block([EKFiber class]);
        return nil;
    }];

    id next;
    while ((next = fiber.resume)) {
        block(next);
    }
    return self;
}

- (id)next
{
    return [self next:NO];
}
- (id)peek
{
    return [self next:YES];
}
- (id)next:(BOOL)peek
{
    // first time around, dispatch the iteration onto our fiber
    if (!self.fiber) {
        __unsafe_unretained EKEnumerator *weakSelf = self;
        self.fiber = [EKFiber fiberWithBlock:^id{
            weakSelf.block([EKFiber class]);
            return nil;
        }];
    }

    id next;
    if (peek) {
        // if we haven't peeked already, resume the iteration and get
        // the next value
        if (!self.lastPeek) {
            self.lastPeek = self.fiber.resume;
        }

        // keep returning the peeked value
        next = self.lastPeek;
    }
    else {
        // if we previously peeked, calling next should just return
        // the last peek
        if (self.lastPeek) {
            next = self.lastPeek;

            // clear the last peek so that we get a new value next time
            self.lastPeek = nil;
        }
        else {
            // get the next value
            next = self.fiber.resume;
        }
    }
    return next;
}

- (id)rewind
{
    // delete the fiber -- the iteration will be restarted next
    // time -next is called
    self.fiber = nil;
    return self;
}

- (id)withIndex:(id (^)(id, id))block
{
    return nil;
}

@end
