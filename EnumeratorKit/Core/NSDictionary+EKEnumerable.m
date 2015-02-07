//
//  NSDictionary+EKEnumerable.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 28/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSDictionary+EKEnumerable.h"

@implementation NSDictionary (EKEnumerable)

+ (void)load
{
    [self includeEKEnumerable];
}

- (instancetype)initWithEnumerable:(id<EKEnumerable>)enumerable
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];

    id __block key;
    [enumerable each:^(id obj) {
        if (key) {
            dictionary[key] = obj;
            key = nil;
        }
        else {
            key = obj;
        }
    }];

    return [self initWithDictionary:dictionary];
}

- (instancetype)each:(void (^)(id))block
{
    return [self eachPair:block];
}

- (instancetype)eachPair:(void (^)(id))block
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(@[key, obj]);
    }];
    return self;
}

- (instancetype)eachEntry:(void (^)(id))block
{
    return [self eachPair:block];
}

- (instancetype)eachKey:(void (^)(id))block
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key);
    }];
    return self;
}

- (instancetype)eachObject:(void (^)(id))block
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj);
    }];
    return self;
}

- (instancetype)map:(id (^)(id))block
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [self eachPair:^(id pair) {
        id mapped = block(pair);
        dictionary[pair[0]] = mapped;
    }];
    return [dictionary copy];
}

- (instancetype)flattenMap:(id<EKEnumerable> (^)(id))block
{
    NSMutableDictionary *results = [NSMutableDictionary new];
    [self eachPair:^(id pair) {
        id result = block(pair) ?: [[self class] new];
        NSAssert([result isKindOfClass:[self class]], @"The block passed to -flattenMap: must return an enumerable of the same type as the receiver.");
        [result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (!results[key]) { results[key] = [NSMutableSet new]; }
            [results[key] addObject:obj];
        }];
    }];
    return [[NSDictionary alloc] initWithDictionary:results copyItems:YES];
}

@end
