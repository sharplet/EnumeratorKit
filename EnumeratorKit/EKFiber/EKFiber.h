//
//  EKFiber.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 17/05/13.
//  Implementation based heavily on https://github.com/alskipp/MacrubyFibers/blob/master/lib/fiber.rb
//

#import <Foundation/Foundation.h>
#import "EKYielder.h"

@interface EKFiber : NSObject

+ (instancetype)fiberWithBlock:(id (^)(id<EKYielder> yielder))block;
- (instancetype)initWithBlock:(id (^)(id<EKYielder> yielder))block;

- (void)yield:(id)obj;

- (id)resume;
- (void)destroy;

@property (nonatomic, readonly) BOOL isAlive;

@end
