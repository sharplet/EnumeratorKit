//
//  NSArray+RFEnumerable.m
//  RFEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSArray+RFEnumerable.h"
#import "RFEnumerator.h"

@implementation NSArray (RFEnumerable)

+ (void)load
{
    [self includeEnumerable];
}

- (id)each:(void (^)(id))block
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
    return self;
}

@end
