//
//  FakeEnumerator.m
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "FakeEnumerator.h"

@implementation FakeEnumerator

- (id)initWithTarget:(id)target selector:(SEL)selector
{
    self = nil;
    return self;
}

- (id)next
{
    return nil;
}

- (id)rewind
{
    return nil;
}

- (id)withIndex:(id (^)(id, id))block
{
    return nil;
}

@end
