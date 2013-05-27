//
//  NSObject+EKEnumerable.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 27/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "NSObject+EKEnumerator.h"
#import "EKEnumerator.h"

@implementation NSObject (EKEnumerator)

- (id<EKEnumerable>)asEnumerator
{
    return [EKEnumerator enumeratorWithObject:self];
}

@end
