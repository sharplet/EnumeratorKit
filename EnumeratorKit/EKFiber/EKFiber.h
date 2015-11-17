//
//  EKFiber.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 17/11/2015.
//  Copyright © 2015 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EnumeratorKit/EKYielder.h>

@interface EKFiber : NSObject

+ (instancetype)fiberWithBlock:(void (^)(id<EKYielder> yielder))block;
- (instancetype)initWithBlock:(void (^)(id<EKYielder> yielder))block;

- (id)resume;

@end
