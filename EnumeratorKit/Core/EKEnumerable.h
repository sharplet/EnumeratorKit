//
//  EKEnumerable.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>


#pragma mark EKEnumerable API

@protocol EKEnumerable <NSObject>

@required
- (id<EKEnumerable>)each:(void (^)(id obj))block;

@optional
- (id<EKEnumerable>)eachWithIndex:(void (^)(id obj, NSUInteger i))block;

- (NSArray *)asArray;
- (NSArray *)take:(NSInteger)number;

- (NSArray *)map:(id (^)(id obj))block;

/**
 Performs a `map:` with the block, returning a single flattened array
 as the result.

     [@[@0, @1, @2] flattenMap:^(id i){
         return @[i, [i stringValue]];
     }];
     // => @[@0, @"0", @1, @"1", @2, @"2"]

 @param block An `EKMapping` block that takes a single object as its
     argument and returns a new object.
 */
- (NSArray *)flattenMap:(id (^)(id obj))block;

/**
 `mapDictionary:` behaves just like `map:` except that it returns an
 `NSDictionary` instead of an `NSArray`.

 @param block A block that maps objects to entries. The dictionary returned
     by this block must not contain more than a single entry.
 */
- (NSDictionary *)mapDictionary:(NSDictionary *(^)(id obj))block;

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

- (NSArray *)select:(BOOL (^)(id obj))block;

- (NSArray *)filter:(BOOL (^)(id obj))block;

- (NSArray *)reject:(BOOL (^)(id obj))block;

- (NSArray *)sort;
- (NSArray *)sortWith:(NSComparator)comparator;

- (NSArray *)sortBy:(id (^)(id obj))block;

- (id)find:(BOOL (^)(id obj))block;

- (id)inject:(SEL)binaryOperation;
- (id)inject:(id)initial withOperation:(SEL)binaryOperation;

- (id)reduce:(id (^)(id memo, id obj))block;
- (id)reduce:(id)initial withBlock:(id (^)(id memo, id obj))block;

#pragma mark Deprecated block property API

- (id<EKEnumerable> (^)(void (^)(id obj)))each DEPRECATED_ATTRIBUTE;
- (id<EKEnumerable> (^)(void (^)(id obj, NSUInteger i)))eachWithIndex DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(NSInteger))take DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(id (^)(id obj)))map DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(id (^)(id obj)))flattenMap DEPRECATED_ATTRIBUTE;
- (NSDictionary * (^)(NSDictionary * (^)(id obj)))mapDictionary DEPRECATED_ATTRIBUTE;
- (NSDictionary * (^)(id<NSCopying> (^)(id obj)))chunk DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(BOOL (^)(id obj)))select DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(BOOL (^)(id obj)))filter DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(BOOL (^)(id obj)))reject DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(NSComparator))sortWith DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(id (^)(id obj)))sortBy DEPRECATED_ATTRIBUTE;
- (id (^)(BOOL (^)(id obj)))find DEPRECATED_ATTRIBUTE;
- (id (^)(id (^)(id memo, id obj)))inject DEPRECATED_ATTRIBUTE;
- (id (^)(id args, ...))reduce DEPRECATED_ATTRIBUTE;

@end

#pragma mark - EKEnumerable mixin

@interface EKEnumerable : NSObject <EKEnumerable>

@end

@interface NSObject (includeEKEnumerable)

+ (void)includeEKEnumerable;

@end
