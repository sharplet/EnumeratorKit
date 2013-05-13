//
//  FakeEnumerable.h
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeEnumerable : NSObject

// abstract methods
- (id)each;
- (id)each:(void (^)(id obj))block;

// collection methods
- (id)map;
- (id)map:(id (^)(id obj))block;
- (id)sortBy:(id (^)(id obj))block;
- (id)filter:(BOOL (^)(id obj))block;
- (id)reduceWithSelector:(SEL)binaryOperation;
- (id)reduce:(id (^)(id memo, id obj))block;

@end
