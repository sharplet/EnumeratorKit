//
//  EKEnumerable.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>

// block types
typedef void (^EKVisitor)(id obj);
typedef void (^EKIndexedVisitor)(id obj, NSUInteger i);
typedef BOOL (^EKPredicate)(id obj);
typedef id (^EKMapping)(id obj);
typedef id<NSCopying> (^EKKeyMapping)(id obj);
typedef NSDictionary * (^EKEntryMapping)(id obj);


#pragma mark EKEnumerable API

@protocol EKEnumerable <NSObject>

@required
- (id<EKEnumerable>)each:(EKVisitor)block;

@optional

- (id<EKEnumerable>)eachWithIndex:(EKIndexedVisitor)block;

- (NSArray *)asArray;
- (NSArray *)take:(NSInteger)number;

- (NSArray *)map:(EKMapping)block;

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
- (NSArray *)flattenMap:(EKMapping)block;

/**
 `mapDictionary:` behaves just like `map:` except that it returns an
 `NSDictionary` instead of an `NSArray`.

 @param block A block that maps objects to entries. The dictionary returned
     by this block must not contain more than a single entry.
 */
- (NSDictionary *)mapDictionary:(EKEntryMapping)block;

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
- (NSDictionary *)chunk:(EKKeyMapping)block;

- (NSArray *)select:(EKPredicate)block;

- (NSArray *)filter:(EKPredicate)block;

- (NSArray *)reject:(EKPredicate)block;

- (NSArray *)sort;
- (NSArray *)sortWith:(NSComparator)comparator;

- (NSArray *)sortBy:(EKMapping)block;

- (id)find:(EKPredicate)block;

- (id)inject:(SEL)binaryOperation;
- (id)inject:(id)initial withOperation:(SEL)binaryOperation;

- (id)reduce:(id (^)(id memo, id obj))block;
- (id)reduce:(id)initial withBlock:(id (^)(id memo, id obj))block;

#pragma mark Deprecated block property API

- (id<EKEnumerable> (^)(EKVisitor))each DEPRECATED_ATTRIBUTE;
- (id<EKEnumerable> (^)(EKIndexedVisitor))eachWithIndex DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(NSInteger))take DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(EKMapping))map DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(EKMapping))flattenMap DEPRECATED_ATTRIBUTE;
- (NSDictionary * (^)(EKEntryMapping))mapDictionary DEPRECATED_ATTRIBUTE;
- (NSDictionary * (^)(EKKeyMapping))chunk DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(EKPredicate))select DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(EKPredicate))filter DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(EKPredicate))reject DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(NSComparator))sortWith DEPRECATED_ATTRIBUTE;
- (NSArray * (^)(EKMapping))sortBy DEPRECATED_ATTRIBUTE;
- (id (^)(EKPredicate))find DEPRECATED_ATTRIBUTE;
- (id (^)(id (^)(id memo, id obj)))inject DEPRECATED_ATTRIBUTE;
- (id (^)(id args, ...))reduce DEPRECATED_ATTRIBUTE;

@end


#pragma mark - EKEnumerable mixin

@interface EKEnumerable : NSObject <EKEnumerable>

@end


@interface NSObject (includeEKEnumerable)

+ (void)includeEKEnumerable;

@end
