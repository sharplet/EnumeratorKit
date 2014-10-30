//
//  EKEnumerable.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <objc/runtime.h>
#import "EnumeratorKit.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
        do { \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
                Stuff; \
            _Pragma("clang diagnostic pop") \
        } while (0)

@implementation EKEnumerable


#pragma mark - Traversal

- (instancetype)each:(void (^)(id))block
{
    NSAssert(NO, @"expected -each: to be implemented");
    return nil;
}

- (instancetype)eachWithIndex:(void (^)(id, NSUInteger))block
{
    __block NSUInteger i = 0;
    [self each:^(id obj) {
        block(obj, i++);
    }];
    return self;
}


#pragma mark Transformations

- (NSArray *)map:(id (^)(id))block
{
    NSMutableArray * result = [NSMutableArray array];
    [self each:^(id obj) {
        id mapped = block(obj);
        [result addObject:(mapped ? mapped : [NSNull null])];
    }];
    return result;
}

- (NSArray *)mapWithIndex:(id (^)(id, NSUInteger))block
{
    NSMutableArray * result = [NSMutableArray new];
    [self eachWithIndex:^(id obj, NSUInteger i) {
        id mapped = block(obj, i);
        [result addObject:mapped];
    }];
    return result;
}

- (NSArray *)flattenMap:(id (^)(id))block
{
    return [[self map:block] flatten];
}

- (NSDictionary *)mapDictionary:(NSDictionary *(^)(id))block
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [self each:^(id obj) {
        NSDictionary *entry = block(obj);
        NSAssert([entry count] <= 1, @"Expected a dictionary with no more than 1 entry (%lu entries)", (unsigned long)[entry count]);

        [dict addEntriesFromDictionary:entry];
    }];
    return [dict copy];
}

- (NSDictionary *)wrap:(id<NSCopying> (^)(id))block
{
    return [self mapDictionary:^NSDictionary *(id obj) {
        return @{block(obj): obj};
    }];
}

- (NSDictionary *)groupBy:(id<NSCopying> (^)(id))block
{
    NSMutableDictionary *groups = [NSMutableDictionary new];
    [self each:^(id obj) {
        id<NSCopying> result = block(obj);
        id<NSCopying> key = result ? result : [NSNull null];

        if (!groups[key]) {
            groups[key] = [NSMutableArray new];
        }

        [groups[key] addObject:obj];
    }];

    // ensure the chunked arrays are immutable
    return [[NSDictionary alloc] initWithDictionary:groups copyItems:YES];
}

- (NSArray *)chunk:(id (^)(id))block
{
    NSMutableArray *chunks = [NSMutableArray new];

    void (^freeze)(NSMutableArray *, NSInteger) = ^(NSMutableArray *array, NSInteger idx){
        if (idx != -1) {
            chunks[idx] = [[NSArray alloc] initWithArray:array[idx] copyItems:YES];
        }
    };

    __block NSInteger count = -1;

    [self each:^(id obj) {
        id result = block(obj);
        id key = result ? result : [NSNull null];

        if (count == -1 || ![chunks[count][0] isEqual:key]) {
            freeze(chunks, count);
            count++;
            [chunks addObject:[NSMutableArray arrayWithObjects:key, [NSMutableArray arrayWithObject:obj], nil]];
        }
        else {
            [chunks[count][1] addObject:obj];
        }
    }];

    freeze(chunks, count);

    return [chunks copy];
}

- (id)reduce:(id (^)(id, id))block
{
    return [self reduce:nil withBlock:block];
}

- (id)reduce:(id)initial withBlock:(id (^)(id, id))block
{
    // if the initial can be mutable (e.g., @[] or @{}), get a mutable copy
    __block id memo = [initial conformsToProtocol:@protocol(NSMutableCopying)] ? [initial mutableCopy] : initial;

    [self each:^(id obj) {
        if (!memo)
            memo = obj;
        else
            memo = block(memo, obj);
    }];

    return [memo conformsToProtocol:@protocol(NSCopying)] ? [memo copy] : memo;
}

- (id)inject:(SEL)binaryOperation
{
    return [self reduce:^id(id memo, id obj) {
        SuppressPerformSelectorLeakWarning(
            return [memo performSelector:binaryOperation withObject:obj];
        );
    }];
}

- (id)inject:(id)initial withOperation:(SEL)binaryOperation
{
    return [self reduce:initial withBlock:^id(id memo, id obj) {
        SuppressPerformSelectorLeakWarning(
            return [memo performSelector:binaryOperation withObject:obj];
        );
    }];
}


#pragma mark Searching and filtering

- (NSArray *)select:(BOOL (^)(id))block
{
    NSMutableArray * result = [NSMutableArray array];
    [self each:^(id obj) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }];
    return [result copy];
}

- (NSArray *)filter:(BOOL (^)(id))block
{
    return [self select:block];
}

- (NSArray *)reject:(BOOL (^)(id))block
{
    NSMutableArray * result = [NSMutableArray array];
    [self each:^(id obj) {
        if (!block(obj)) {
            [result addObject:obj];
        }
    }];
    return [result copy];
}


#pragma mark Sorting

- (NSArray *)sort
{
    return [self.asArray sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)sortWith:(NSComparator)comparator
{
    return [self.asArray sortedArrayUsingComparator:comparator];
}

- (NSArray *)sortBy:(id (^)(id))block
{
    return [[[self map:^(id i){
        return @[block(i), i];
    }] sort] map:^(id a) {
        return a[1];
    }];
}

- (id)find:(BOOL (^)(id))block
{
    id next;
    EKEnumerator *e = self.asEnumerator;
    while ((next = e.next)) {
        if (block(next)) {
            return next;
        }
    }
    return nil;
}

- (BOOL)any:(BOOL (^)(id obj))block
{
    return [self find:block] != nil;
}

- (BOOL)all:(BOOL (^)(id obj))block
{
    id next;
    EKEnumerator *e = self.asEnumerator;
    while ((next = e.next)) {
        if (!block(next)) {
            return NO;
        }
    }
    return YES;
}


#pragma mark Other methods

- (NSArray *)take:(NSInteger)number
{
    NSMutableArray *result = [NSMutableArray array];
    EKEnumerator *e = self.asEnumerator;

    NSInteger count = 0;
    while (e.peek && (number < 0 || ++count <= number)) {
        [result addObject:e.next];
    }

    return result;
}

- (NSArray *)asArray
{
    return [self take:-1];
}

@end


#pragma mark - EKEnumerable mixin

@implementation NSObject (includeEKEnumerable)

+ (void)includeEKEnumerable
{
    unsigned int methodCount;
    Method *methods = class_copyMethodList([EKEnumerable class], &methodCount);

    for (unsigned i = 0; i < methodCount; i++) {
        SEL name = method_getName(methods[i]);
        IMP imp = method_getImplementation(methods[i]);
        const char *types = method_getTypeEncoding(methods[i]);

        class_addMethod([self class], name, imp, types);
    }

    free(methods);
}

@end
