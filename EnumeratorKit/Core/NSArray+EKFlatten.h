//
//  NSArray+EKFlatten.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 23/07/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+EKEnumerable.h"

/**
 Extends NSArray with a single method `-flatten` to recursively build a
 single-level array with all objects from all child arrays.
 */
@interface NSArray (EKFlatten)

/**
 Recursively builds a new array by adding all objects from all child
 arrays. The order of children is preserved. For example:

    [@[@[@1, @2], @3] flatten] // => @[@1, @2, @3]

 and

    @[@1, @[@2, @[@3, @4]], @5, @[@6]] // => @[@1, @2, @3, @4, @5, @6]
 */
- (NSArray *)flatten;

@end
