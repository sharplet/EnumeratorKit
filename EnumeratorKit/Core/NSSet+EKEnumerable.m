//
//  NSSet+EKEnumerable.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 28/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSSet+EKEnumerable.h"

@implementation NSSet (EKEnumerable)

+ (void)load
{
    [self includeEKEnumerable];
}

- (instancetype)each:(void (^)(id))block
{
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj);
    }];
    return self;
}

// overrides -[EKEnumerable asArray]
- (NSArray *)asArray
{
    return [self allObjects];
}

@end
