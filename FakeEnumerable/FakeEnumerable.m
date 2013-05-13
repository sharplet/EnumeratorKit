//
//  FakeEnumerable.m
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "FakeEnumerable.h"

@implementation FakeEnumerable

- (id)each
{
    NSAssert(NO, @"-each must be overridden by subclass");
    return nil;
}
- (id)each:(void (^)(id))block
{
    NSAssert(NO, @"-each: must be overridden by subclass");
    return nil;
}

- (id)map
{
    return nil;
}
- (id)map:(id (^)(id))block
{
    return nil;
}

- (id)sortBy:(id (^)(id))block
{
    return nil;
}

- (id)filter:(BOOL (^)(id))block
{
    return nil;
}

- (id)reduceWithSelector:(SEL)binaryOperation
{
    return nil;
}

- (id)reduce:(id (^)(id, id))block
{
    return nil;
}

@end
