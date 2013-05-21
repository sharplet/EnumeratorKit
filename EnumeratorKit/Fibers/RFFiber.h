//
//  RFFiber.h
//  RFEnumerable
//
//  Created by Adam Sharp on 17/05/13.
//  Implementation based heavily on https://github.com/alskipp/MacrubyFibers/blob/master/lib/fiber.rb
//

#import <Foundation/Foundation.h>

@interface RFFiber : NSObject

+ (instancetype)fiberWithBlock:(id (^)(void))block;
- (id)initWithBlock:(id (^)(void))block;

+ (instancetype)current;
+ (void)yield:(id)obj;

- (id)resume;

@property (nonatomic, readonly) BOOL isAlive;
@property (nonatomic, readonly) NSString *label;

@end
