//
//  EKEnumerable.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EKEnumerable <NSObject>

@required
- (id<EKEnumerable>)each:(void (^)(id obj))block;

@optional
- (id<EKEnumerable> (^)(void (^)(id obj)))each;

- (id<EKEnumerable>)eachWithIndex:(void (^)(id obj, NSUInteger i))block;
- (id<EKEnumerable> (^)(void (^)(id obj, NSUInteger i)))eachWithIndex;

- (NSArray *)asArray;
- (NSArray *)take:(NSInteger)number;
- (NSArray * (^)(NSInteger))take;

- (NSArray *)map:(id (^)(id obj))block;
- (NSArray * (^)(id (^)(id obj)))map;

- (NSArray *)filter:(BOOL (^)(id obj))block;
- (NSArray * (^)(BOOL (^)(id obj)))filter;

- (NSArray *)sort;
- (NSArray *)sortWith:(NSComparator)comparator;
- (NSArray * (^)(NSComparator))sortWith;

- (NSArray *)sortBy:(id (^)(id obj))block;
- (NSArray * (^)(id (^)(id obj)))sortBy;

- (id<EKEnumerable>)inject:(SEL)binaryOperation;
- (id<EKEnumerable>)inject:(id)initial withOperation:(SEL)binaryOperation;
- (id<EKEnumerable> (^)(id (^)(id memo, id obj)))inject;

- (id<EKEnumerable>)reduce:(id (^)(id memo, id obj))block;
- (id<EKEnumerable>)reduce:(id)initial withBlock:(id (^)(id memo, id obj))block;
- (id<EKEnumerable> (^)(id args, ...))reduce;

@end

@interface EKEnumerable : NSObject <EKEnumerable>

@end

@interface NSObject (IncludeEKEnumerable)
+ (void)includeEnumerable;
@end
