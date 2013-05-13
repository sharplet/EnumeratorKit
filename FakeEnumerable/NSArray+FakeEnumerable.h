//
//  NSArray+FakeEnumerable.h
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FakeEnumerable)

- (id)each;
- (id)each:(void (^)(id))block;

@end
