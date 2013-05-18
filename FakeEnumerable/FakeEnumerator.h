//
//  FakeEnumerator.h
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeEnumerator : NSObject

- (id)initWithTarget:(id)target selector:(SEL)selector;

- (id)each;
- (id)each:(void (^)(id obj))block;

- (id)next;
- (id)rewind;
- (id)withIndex:(id (^)(id obj, id index))block;

@end
