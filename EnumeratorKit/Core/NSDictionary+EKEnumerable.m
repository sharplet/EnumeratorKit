//
//  NSDictionary+EKEnumerable.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 28/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSDictionary+EKEnumerable.h"

@implementation NSDictionary (EKEnumerable)

- (id<EKEnumerable>)each:(void (^)(id))block
{
    return [self eachPair:block];
}

- (id<EKEnumerable>)eachPair:(void (^)(id))block
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

- (id<EKEnumerable>)eachEntry:(void (^)(id))block
{
    return [self eachPair:block];
}
- (id<EKEnumerable> (^)(void (^)(id)))eachEntry
{
    return ^id<EKEnumerable>(void (^block)(NSArray *)) {
        return [self eachEntry:block];
    };
}

@end
