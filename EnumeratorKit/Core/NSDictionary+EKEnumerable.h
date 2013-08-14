//
//  NSDictionary+EKEnumerable.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 28/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumeratorKit.h"

@interface NSDictionary (EKEnumerable) <EKEnumerable>

- (instancetype)eachEntry:(void (^)(id entry))block;
- (instancetype)eachPair:(void (^)(id pair))block;
- (id<EKEnumerable> (^)(void (^)(id entry)))eachEntry;
- (id<EKEnumerable> (^)(void (^)(id pair)))eachPair;

- (instancetype)eachKey:(void (^)(id key))block;
- (id<EKEnumerable> (^)(void (^)(id key)))eachKey;

- (instancetype)eachObject:(void (^)(id obj))block;
- (id<EKEnumerable> (^)(void (^)(id obj)))eachObject;

@end
