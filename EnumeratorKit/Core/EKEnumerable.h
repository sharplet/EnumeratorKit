//
//  EKEnumerable.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>

/**
 The `EKEnumerable` protocol and mixin provide a number of methods for
 traversing, searching and sorting collection classes. To include the
 `EKEnumerable` mixin, collection classes need to:

 1. Adopt the `EKEnumerable` protocol
 2. Implement `+load` and call `[self includeEKEnumerable]`
 3. Implement `-each:` to traverse the collection, applying the block
    to each element.
 */
@protocol EKEnumerable <NSObject>

@required

#pragma mark - Traversal
/** @name Traversal */

/**
 Collection classes must implement this method to traverse each element
 in the collection, applying the block to each element.

 Example:

    NSArray *greetings = @[@"Hello", @"Hi"];
    [numbers each:^(id greeting){
        NSLog(@"%@, world", greeting);
    }];

 @param block A block that accepts a single object.

 @return Your implementation of this method should return `self`.
 */
- (instancetype)each:(void (^)(id obj))block;

@optional

/**
 Iterate the block over each element in the collection, calling the
 block with two arguments: the object and its index (starting at 0).

 Usage:

    NSMutableArray *array = [NSMutableArray array];
    [@[@"peach", @"pear", @"plum"] eachWithIndex:^(id fruit, NSUInteger i){
        [array addObject:[NSString stringWithFormat:@"%d: %@", i, fruit]];
    }];
    // => @[@"0: peach", @"1: pear", @"2: plum"]

 @param block A block that accepts an object and an `NSUInteger` index.

 @return This method returns `self` after the enumeration is complete.
 */
- (instancetype)eachWithIndex:(void (^)(id obj, NSUInteger i))block;


#pragma mark Transformations
/** @name Transformations */

/**
 Applies the block to each element in the collection, and collects
 the return values in an array. If the block returns `nil`,
 `[NSNull null]` will automatically be inserted into the array.

 Usage:

    Animal *dog = [Animal animalWithName:@"Spike"];
    Animal *cat = [Animal animalWithName:@"Princess"];

    [@[dog, cat] map:^(id pet){
        return [pet name];
    }];
    // => @[@"Spike", @"Princess"];

 @param block A block that accepts a single object and returns an object.

 @return Returns a new array with the results of applying the block to
    each element in the collection. The resulting array will always
    have the same count as the receiver.
 */
- (NSArray *)map:(id (^)(id obj))block;

/**
 Performs a `map:` with the block, returning a single flattened array
 as the result.

 Usage:

     [@[@0, @1, @2] flattenMap:^(id i){
         return @[i, [i stringValue]];
     }];
     // => @[@0, @"0", @1, @"1", @2, @"2"]

 @param block A block that accepts a single object and returns an
    object. Returning an array will cause the *contents* of the array to
    be flattened and added to the result array.

 @return A flattened array with the results of applying a `map:` with
    the block.
 */
- (NSArray *)flattenMap:(id (^)(id obj))block;

/**
 `mapDictionary:` behaves just like `map:` except that it returns an
 `NSDictionary` instead of an `NSArray`.

 Usage:

    NSDictionary *apple = @{ @"id": @1, @"name": @"Apple", @"grows_on": @"tree" };
    NSDictionary *grape = @{ @"id": @2, @"name": @"Grape", @"grows_on": @"vine" };

    NSDictionary *fruits = [@[banana, apple] mapDictionary:^(id fruit){
        return @{ fruit[@"name"]: fruit };
    }];

    fruits[@"Apple"][@"grows_on"]; // => @"tree"

 **Note:** If the block returns a key that already exists in the
 dictionary (i.e., if two elements return the same key while iterating),
 the last value for that key will end up in the resulting dictionary.
 Later values in the enumeration for the same key will replace earlier
 values for that key.

 @param block A block that maps objects to entries. The dictionary returned
    by this block must not contain more than a single entry.

 @return A dictionary containing all the entries returned by the block.
 */
- (NSDictionary *)mapDictionary:(NSDictionary *(^)(id obj))block;

/**
 Takes the key returned by the block and "wraps" the element with it
 as a key-value pair.

 `wrap:` is a shorthand for this usage of `mapDictionary:`

    [collection mapDictionary:^(id obj){
        return @{ obj[@"key"]: obj };
    }];

 which becomes

    [collection wrap:^(id obj){
        return obj[@"key"];
    }];

 **Note:** Like `mapDictionary:`, if the block returns duplicate keys,
 later values in the enumeration for the same key will replace earlier
 values for that key.

 @param block A block that returns a unique key for an object.

 @return A dictionary with the block's results as keys, mapped to the
    objects as values.
 */
- (NSDictionary *)wrap:(id<NSCopying> (^)(id obj))block;

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

/** Accumulates a result by applying the block to successive pairs of elements. */
- (id)reduce:(id (^)(id memo, id obj))block;

/** Given an initial value, accumulates a result by applying the block to successive pairs of elements. */
- (id)reduce:(id)initial withBlock:(id (^)(id memo, id obj))block;

/** Accumulates a result by "injecting" the operation between successive pairs of elements. */
- (id)inject:(SEL)binaryOperation;

/** Given an initial value, accumulates a result by "injecting" the operation between successive pairs of elements. */
- (id)inject:(id)initial withOperation:(SEL)binaryOperation;


#pragma mark Searching and filtering
/** @name Searching and filtering */

/**
 Applies the block to each element in the collection and returns a new
 collection with only the elements for which the block returns `YES`.

 Usage:

    - (NSArray *)finishedOperations
    {
        return [self.operations select:^(id op){
            return [op isFinished];
        }];
    }

 @param block A block that accepts an an object and returns `YES` if
    the object should be kept, and `NO` if it should be removed.

 @return A filtered array containing all the objects for which the
    block returned `YES`.
 */
- (NSArray *)select:(BOOL (^)(id obj))block;

/**
 Alias for `select:`.
 */
- (NSArray *)filter:(BOOL (^)(id obj))block;

/**
 Like `select:`, but instead returns the elements for which the block
 returns `NO`. Thus, if the block returns `YES`, the element is removed
 from the collection.

 Usage:

    - (NSArray *)nonEmptyStrings
    {
        return [self.strings reject:^(id s){
            return [s length] == 0;
        }];
    }

 @param block A block that accepts an an object and returns `NO` if
    the object should be kept, and `YES` if it should be removed.

 @return A filtered array containing all the objects for which the
    block returned `NO`.
 */
- (NSArray *)reject:(BOOL (^)(id obj))block;

/** Find the first matching element in a collection. */
- (id)find:(BOOL (^)(id obj))block;


#pragma mark Sorting
/** @name Sorting */

/** Sorts the collection by sending `compare:` to successive pairs of elements. */
- (NSArray *)sort;

/** Sorts the collection using the given comparator. */
- (NSArray *)sortWith:(NSComparator)comparator;

/** Sort the collection, using the return values of the block as the sort key for comparison. */
- (NSArray *)sortBy:(id (^)(id obj))block;


#pragma mark Other methods
/** @name Other methods */

/** Take elements from a collection */
- (NSArray *)take:(NSInteger)number;

/** Get an array */
- (NSArray *)asArray;


#pragma mark - Deprecated block property API

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
