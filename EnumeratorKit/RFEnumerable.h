//
//  RFEnumerable.h
//  RFEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFEnumerable <NSObject>

@required
- (id<RFEnumerable>)each:(void (^)(id obj))block;

@optional
- (id<RFEnumerable>)each;

- (id<RFEnumerable>)map;
- (id<RFEnumerable>)map:(id (^)(id obj))block;
- (id<RFEnumerable>)sortBy:(id (^)(id obj))block;
- (id<RFEnumerable>)filter:(BOOL (^)(id obj))block;

- (id<RFEnumerable>)inject:(SEL)binaryOperation;
- (id<RFEnumerable>)reduce:(id (^)(id memo, id obj))block;

@end

@interface RFEnumerable : NSObject <RFEnumerable>

@end

@interface NSObject (IncludeRFEnumerable)
+ (void)includeEnumerable;
@end
