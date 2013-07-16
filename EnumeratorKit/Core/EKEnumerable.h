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

/**
 Applies the block to each item in the collection, using the result as
 the item's key. Returns a dictionary of arrays grouped by the set of
 keys returned by the block.

     [@[@3, @1, @2] chunk:^(id num){
         if ([num integerValue] % 2 == 0) {
             return @"even";
         }
         else {
             return @"odd";
         }
     }];
     // => @{ @"even": @[@2], @"odd": @[@3, @1] }

 @param block A block whose return value will be used as a key to group
     the item by.
 */
- (NSDictionary *)chunk:(id<NSCopying> (^)(id obj))block;
- (NSDictionary * (^)(id<NSCopying> (^)(id obj)))chunk;

- (NSArray *)filter:(BOOL (^)(id obj))block;
- (NSArray * (^)(BOOL (^)(id obj)))filter;

- (NSArray *)sort;
- (NSArray *)sortWith:(NSComparator)comparator;
- (NSArray * (^)(NSComparator))sortWith;

- (NSArray *)sortBy:(id (^)(id obj))block;
- (NSArray * (^)(id (^)(id obj)))sortBy;

- (id)find:(BOOL (^)(id obj))block;
- (id (^)(BOOL (^)(id obj)))find;

- (id)inject:(SEL)binaryOperation;
- (id)inject:(id)initial withOperation:(SEL)binaryOperation;
- (id<EKEnumerable> (^)(id (^)(id memo, id obj)))inject;

- (id<EKEnumerable>)reduce:(id (^)(id memo, id obj))block;
- (id<EKEnumerable>)reduce:(id)initial withBlock:(id (^)(id memo, id obj))block;
- (id<EKEnumerable> (^)(id args, ...))reduce;

@end

@interface EKEnumerable : NSObject <EKEnumerable>

@end

@interface NSObject (includeEKEnumerable)

+ (void)includeEKEnumerable;

@end
