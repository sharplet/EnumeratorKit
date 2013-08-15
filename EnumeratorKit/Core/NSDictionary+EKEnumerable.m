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
- (id<EKEnumerable> (^)(void (^)(id)))eachPair
{
    return ^id<EKEnumerable>(void (^block)(NSArray *)) {
        return [self eachPair:block];
    };
}

- (instancetype)eachEntry:(void (^)(id))block
{
    return [self eachPair:block];
}
- (id<EKEnumerable> (^)(void (^)(id)))eachEntry
{
    return ^id<EKEnumerable>(void (^block)(NSArray *)) {
        return [self eachEntry:block];
    };
}

- (instancetype)eachKey:(void (^)(id))block
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key);
    }];
    return self;
}
- (id<EKEnumerable> (^)(void (^)(id obj)))eachKey
{
    return ^id<EKEnumerable>(void (^block)(id)) {
        return [self eachKey:block];
    };
}

- (instancetype)eachObject:(void (^)(id))block
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj);
    }];
    return self;
}
- (id<EKEnumerable> (^)(void (^)(id obj)))eachObject
{
    return ^id<EKEnumerable>(void (^block)(id)) {
        return [self eachObject:block];
    };
}

@end
