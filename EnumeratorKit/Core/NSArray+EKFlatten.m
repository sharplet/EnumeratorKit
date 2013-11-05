//
//  NSArray+EKFlatten.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 23/07/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSArray+EKFlatten.h"

@implementation NSArray (EKFlatten)

- (NSArray *)flatten
{
    // a flattened array will have at least as many elements as the original
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];

    BOOL hasNestedArrays = NO;
    for (id obj in self) {
        if ([obj isKindOfClass:[NSArray class]]) {
            hasNestedArrays = YES;
            [result addObjectsFromArray:[obj flatten]];
        }
        else {
            [result addObject:obj];
        }
    }

    return hasNestedArrays ? [result copy] : self;
}

@end
