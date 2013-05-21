//
//  RFEnumerator.h
//  RFEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFEnumerable.h"

@protocol RFYielder <NSObject>
- (void)yield:(id)obj;
@end

@interface RFEnumerator : NSObject <RFEnumerable>

+ (instancetype)enumeratorWithBlock:(void (^)(id<RFYielder> y))block;
- (id)initWithBlock:(void (^)(id<RFYielder> y))block;

- (id)next;
- (id)peek;
- (id)rewind;
- (id)withIndex:(id (^)(id obj, id index))block;

@end
