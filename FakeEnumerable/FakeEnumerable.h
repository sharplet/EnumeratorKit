//
//  FakeEnumerable.h
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FakeEnumerable <NSObject>

@required
- (id<FakeEnumerable>)each:(void (^)(id obj))block;

@optional
- (id<FakeEnumerable>)each;

- (id<FakeEnumerable>)map;
- (id<FakeEnumerable>)map:(id (^)(id obj))block;
- (id<FakeEnumerable>)sortBy:(id (^)(id obj))block;
- (id<FakeEnumerable>)filter:(BOOL (^)(id obj))block;

- (id<FakeEnumerable>)inject:(SEL)binaryOperation;
- (id<FakeEnumerable>)reduce:(id (^)(id memo, id obj))block;

@end

@interface FakeEnumerable : NSObject <FakeEnumerable>

@end

@interface NSObject (IncludeFakeEnumerable)
+ (void)includeEnumerable;
@end
