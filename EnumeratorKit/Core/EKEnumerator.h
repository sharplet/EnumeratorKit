//
//  EKEnumerator.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKEnumerable.h"

@protocol EKYielder <NSObject>
- (void)yield:(id)obj;
@end

@interface EKEnumerator : NSObject <EKEnumerable>

+ (instancetype)enumeratorWithObject:(id)object;
- (id)initWithObject:(id)object;

+ (instancetype)enumeratorWithBlock:(void (^)(id<EKYielder> y))block;
- (id)initWithBlock:(void (^)(id<EKYielder> y))block;

- (id)next;
- (id)peek;
- (id)rewind;

@end
