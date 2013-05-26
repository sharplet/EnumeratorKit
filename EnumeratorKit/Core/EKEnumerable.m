//
//  EKEnumerable.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <objc/runtime.h>
#import "SuppressPerformSelectorMemoryWarnings.h"

@implementation EKEnumerable

- (id<EKEnumerable>)each:(void (^)(id obj))block
{
    NSAssert(NO, @"expected -each: to be implemented");
    return nil;
}
- (id<EKEnumerable> (^)(void (^)(id obj)))each
{
    return ^id<EKEnumerable>(void (^block)(id obj)) {
        return [self each:block];
    };
}

- (id<EKEnumerable>)map:(id (^)(id))block
{
    NSMutableArray * result = [NSMutableArray array];
    [self each:^(id obj) {
        [result addObject:block(obj)];
    }];
    return result;
}

- (id<EKEnumerable>)sortBy:(id (^)(id))block
{
    return nil;
}

- (id<EKEnumerable>)filter:(BOOL (^)(id))block
{
    NSMutableArray * result = [NSMutableArray array];
    [self each:^(id obj) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }];
    return result;
}

- (id<EKEnumerable>)inject:(SEL)binaryOperation
{
    return [self reduce:^id(id memo, id obj) {
        SuppressPerformSelectorLeakWarning(
            return [memo performSelector:binaryOperation withObject:obj];
        );
    }];
}

- (id<EKEnumerable>)reduce:(id (^)(id, id))block
{
    return [self reduce:nil withBlock:block];
}
- (id<EKEnumerable>)reduce:(id)initial withBlock:(id (^)(id, id))block
{
    __block id memo = initial;
    [self each:^(id obj) {
        if (!memo)
            memo = obj;
        else
            memo = block(memo, obj);
    }];
    return memo;
}

@end

@implementation NSObject (IncludeEKEnumerable)

+ (void)includeEnumerable
{
    unsigned int methodCount;
    Method *methods = class_copyMethodList([EKEnumerable class], &methodCount);

    for (int i = 0; i < methodCount; i++) {
        SEL name = method_getName(methods[i]);
        IMP imp = method_getImplementation(methods[i]);
        const char *types = method_getTypeEncoding(methods[i]);

        class_addMethod([self class], name, imp, types);
    }

    free(methods);
}

@end
