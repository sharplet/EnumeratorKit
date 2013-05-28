//
//  NSOrderedSet+EKEnumerable.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 28/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSOrderedSet+EKEnumerable.h"

@implementation NSOrderedSet (EKEnumerable)

- (id<EKEnumerable>)each:(void (^)(id))block
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
    return self;
}

// overrides -[EKEnumerable asArray]
- (NSArray *)asArray
{
    return [self array];
}

@end
