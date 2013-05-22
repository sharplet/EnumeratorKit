//
//  RFEnumerable.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <objc/runtime.h>
#import "SuppressPerformSelectorMemoryWarnings.h"

@implementation RFEnumerable

- (id<RFEnumerable>)each
{
    return [RFEnumerator enumeratorWithBlock:^(id<RFYielder> y) {
        [self each:^(id obj) {
            [y yield:obj];
        }];
    }];
}
- (id<RFEnumerable>)each:(void (^)(id obj))block
{
    NSAssert(NO, @"expected -each: to be implemented");
    return nil;
}

- (id<RFEnumerable>)map
{
    // FIXME: initially, should probably ignore the block-less forms and stick with -each
    //
    // This won't work: [@[...].map each:...]
    // But we should start with this: [@[...] map:...].each
    //
    // Ruby allows both but probably don't need to be quite so smart for a 0.1 due
    // to lack of dynamic block support and implicit returns.
    //
    // Basically, we will only be able to get an RFEnumerable at the end
    // of the chain (with -each)??
    return [[RFEnumerator alloc] initWithBlock:^(id<RFYielder> y) {
        [self map:^id(id obj) {
            [y yield:obj];
            return obj;
        }];
    }];
}
- (id<RFEnumerable>)map:(id (^)(id))block
{
    NSMutableArray * result = [NSMutableArray array];
    [self each:^(id obj) {
        [result addObject:block(obj)];
    }];
    return result;
}

- (id<RFEnumerable>)sortBy:(id (^)(id))block
{
    return nil;
}

- (id<RFEnumerable>)filter:(BOOL (^)(id))block
{
    NSMutableArray * result = [NSMutableArray array];
    [self each:^(id obj) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }];
    return result;
}

- (id<RFEnumerable>)inject:(SEL)binaryOperation
{
    return [self reduce:^id(id memo, id obj) {
        SuppressPerformSelectorLeakWarning(
            return [memo performSelector:binaryOperation withObject:obj];
        );
    }];
}

- (id<RFEnumerable>)reduce:(id (^)(id, id))block
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

@implementation NSObject (IncludeRFEnumerable)

+ (void)includeEnumerable
{
    unsigned int methodCount;
    Method *methods = class_copyMethodList([RFEnumerable class], &methodCount);

    for (int i = 0; i < methodCount; i++) {
        SEL name = method_getName(methods[i]);
        IMP imp = method_getImplementation(methods[i]);
        const char *types = method_getTypeEncoding(methods[i]);

        class_addMethod([self class], name, imp, types);
    }

    free(methods);
}

@end
