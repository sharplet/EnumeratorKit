//
//  FakeEnumerator.h
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FakeEnumerable.h"

@protocol Yielder <NSObject>
- (void)yield:(id)obj;
@end

@interface FakeEnumerator : NSObject <FakeEnumerable>

+ (instancetype)enumeratorWithBlock:(void (^)(id<Yielder> y))block;
- (id)initWithBlock:(void (^)(id<Yielder> y))block;

- (id)next;
- (id)peek;
- (id)rewind;
- (id)withIndex:(id (^)(id obj, id index))block;

@end
