//
//  EKFiber.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 17/05/13.
//  Implementation based heavily on https://github.com/alskipp/MacrubyFibers/blob/master/lib/fiber.rb
//

#import <Foundation/Foundation.h>

@interface EKFiber : NSObject

+ (instancetype)fiberWithBlock:(id (^)(void))block;
- (id)initWithBlock:(id (^)(void))block;

+ (instancetype)current;
+ (void)yield:(id)obj;

- (id)resume;
- (void)destroy;

@property (nonatomic, readonly) BOOL isAlive;
@property (nonatomic, readonly) NSString *label;

@end
