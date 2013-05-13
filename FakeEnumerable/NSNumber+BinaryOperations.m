//
//  NSNumber+BinaryOperations.m
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSNumber+BinaryOperations.h"

@implementation NSNumber (BinaryOperations)

- (instancetype)add:(NSNumber *)number
{
    return @([self doubleValue] + [number doubleValue]);
}

@end
