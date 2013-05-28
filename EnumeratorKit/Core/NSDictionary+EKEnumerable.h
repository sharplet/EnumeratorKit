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

- (id<EKEnumerable>)eachEntry:(void (^)(id entry))block;
- (id<EKEnumerable>)eachPair:(void (^)(id pair))block;
- (id<EKEnumerable> (^)(void (^)(id entry)))eachEntry;
- (id<EKEnumerable> (^)(void (^)(id pair)))eachPair;

- (id<EKEnumerable>)eachKey:(void (^)(id key))block;
- (id<EKEnumerable> (^)(void (^)(id key)))eachKey;

- (id<EKEnumerable>)eachObject:(void (^)(id obj))block;
- (id<EKEnumerable> (^)(void (^)(id obj)))eachObject;

@end
