//
//  NSArray+FakeEnumerable.m
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSArray+FakeEnumerable.h"
#import "FakeEnumerator.h"

@implementation NSArray (FakeEnumerable)

- (id)each
{
    return [FakeEnumerator enumeratorWithBlock:^(id<Yielder> y) {
        [self each:^(id obj) {
            [y yield:obj];
        }];
    }];
}

- (id)each:(void (^)(id))block
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
    return self;
}

@end
