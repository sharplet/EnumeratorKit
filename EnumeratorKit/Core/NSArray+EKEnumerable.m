//
//  NSArray+EKEnumerable.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSArray+EKEnumerable.h"

@implementation NSArray (EKEnumerable)

+ (void)load
{
    [self includeEKEnumerable];
}

- (id)each:(void (^)(id))block
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
    return self;
}

// overrides -[EKEnumerable asArray]
- (NSArray *)asArray
{
    return self;
}

- (NSComparisonResult)compare:(NSArray *)array
{
    NSComparisonResult result = NSOrderedSame;
    NSUInteger countA = self.count, countB = array.count;

    if (countA == 0)
        result = NSOrderedDescending;
    else if (countB == 0)
        result = NSOrderedAscending;
    else
        result = [self[0] compare:array[0]];

    return result;
}

@end
