//
//  EKEnumerator.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKEnumerable.h"
#import "EKYielder.h"

@interface EKEnumerator : NSObject <EKEnumerable>

+ (instancetype)enumeratorWithObject:(id)object;
- (instancetype)initWithObject:(id)object;

+ (instancetype)new:(void (^)(id<EKYielder> yielder))block;
+ (instancetype)enumeratorWithBlock:(void (^)(id<EKYielder> yielder))block;
- (instancetype)initWithBlock:(void (^)(id<EKYielder> yielder))block;

- (id)next;
- (id)peek;
- (id)rewind;

@end
