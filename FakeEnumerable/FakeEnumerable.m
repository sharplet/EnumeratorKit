//
//  FakeEnumerable.m
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <objc/runtime.h>
#import "FakeEnumerable.h"
#import "FakeEnumerator.h"
#import "NSArray+FakeEnumerable.h"
#import "SuppressPerformSelectorMemoryWarnings.h"

@implementation FakeEnumerable

- (id<FakeEnumerable>)each
{
    return [FakeEnumerator enumeratorWithBlock:^(id<Yielder> y) {
        [self each:^(id obj) {
            [y yield:obj];
        }];
    }];
}
- (id<FakeEnumerable>)each:(void (^)(id obj))block
{
    NSAssert(NO, @"expected -each: to be implemented");
    return nil;
}

- (id<FakeEnumerable>)map
{
    return nil;
}
- (id<FakeEnumerable>)map:(id (^)(id))block
{
    NSMutableArray * result = [NSMutableArray array];
    [self each:^(id obj) {
        [result addObject:block(obj)];
    }];
    return result;
}

- (id<FakeEnumerable>)sortBy:(id (^)(id))block
{
    return nil;
}

- (id<FakeEnumerable>)filter:(BOOL (^)(id))block
{
    NSMutableArray * result = [NSMutableArray array];
    [self each:^(id obj) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }];
    return result;
}

- (id<FakeEnumerable>)inject:(SEL)binaryOperation
{
    return [self reduce:^id(id memo, id obj) {
        SuppressPerformSelectorLeakWarning(
            return [memo performSelector:binaryOperation withObject:obj];
        );
    }];
}

- (id<FakeEnumerable>)reduce:(id (^)(id, id))block
{
    __block id memo;
    [self each:^(id obj) {
        if (!memo)
            memo = obj;
        else
            memo = block(memo, obj);
    }];
    return memo;
}

@end

@implementation NSObject (IncludeFakeEnumerable)

+ (void)includeEnumerable
{
    unsigned int methodCount;
    Method *methods = class_copyMethodList([FakeEnumerable class], &methodCount);

    for (int i = 0; i < methodCount; i++) {
        SEL name = method_getName(methods[i]);
        IMP imp = method_getImplementation(methods[i]);
        const char *types = method_getTypeEncoding(methods[i]);

        class_addMethod([self class], name, imp, types);
    }

    free(methods);
}

@end
