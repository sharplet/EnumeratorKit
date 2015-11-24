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

@end
