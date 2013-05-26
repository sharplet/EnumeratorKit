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
- (id<EKEnumerable> (^)(id (^)(id)))map
{
    return ^id<EKEnumerable>(id (^block)(id obj)) {
        return [self map:block];
    };
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
    return [self inject:nil withOperation:binaryOperation];
}
- (id<EKEnumerable>)inject:(id)initial withOperation:(SEL)binaryOperation
{
    return [self reduce:initial withBlock:^id(id memo, id obj) {
        SuppressPerformSelectorLeakWarning(
            return [memo performSelector:binaryOperation withObject:obj];
        );
    }];
}
- (id<EKEnumerable> (^)(id (^)(id memo, id obj)))inject
{
    return ^id<EKEnumerable>(id (^block)(id,id)) {
        return [self reduce:block];
    };
}

- (id<EKEnumerable>)reduce:(id (^)(id, id))block
{
    return [self reduce:nil withBlock:block];
}
- (id<EKEnumerable>)reduce:(id)initial withBlock:(id (^)(id, id))block
{
    // if the initial can be mutable (e.g., @[] or @{}), get a mutable copy
    __block id memo = [initial respondsToSelector:@selector(mutableCopyWithZone:)] ? [initial mutableCopy] : initial;

    [self each:^(id obj) {
        if (!memo)
            memo = obj;
        else
            memo = block(memo, obj);
    }];
    return memo;
}
- (id<EKEnumerable> (^)(id, ...))reduce
{
    return ^id<EKEnumerable>(id args, ...) {
        // determine if we're using the 1 or 2 arg form from the
        // type of the first arg
        BOOL isEmptyCollection = [args respondsToSelector:@selector(count)] && [args count] == 0;
        BOOL canBeMutable = [args respondsToSelector:@selector(mutableCopyWithZone:)];
        BOOL isNSNumber = [args isKindOfClass:[NSNumber class]];

        int argc = (isEmptyCollection || canBeMutable || isNSNumber) ? 2 : 1;

        // capture the arg(s)
        id memo = nil;
        id (^block)(id,id);
        if (argc == 2) {
            va_list arglist;
            va_start(arglist, args);
            memo = args;
            block = va_arg(arglist, id);
            va_end(arglist);
        }
        else {
            block = args;
        }

        // execute the real implementation of reduce:
        return [self reduce:memo withBlock:block];
    };
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
