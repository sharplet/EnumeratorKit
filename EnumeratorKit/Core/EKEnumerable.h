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

 For example:

    // MyCollection.h
    @interface MyCollection : NSObject <EKEnumerable>

    @end

    // MyCollection.m
    @implementation

    + (void)load
    {
        [self includeEKEnumerable];
    }

    - (instancetype)each:(void (^)(id))block
    {
        for (id obj in self.data) {
            block(obj);
        }
        return self;
    }

    @end
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
- (NSDictionary *)groupBy:(id<NSCopying> (^)(id obj))block;

/**
 Applies the block to each item in the collection, using the result as
 the item's key. Returns an array of pairs of the form

    @[ key, @[first match, second match] ]

 This method behaves like `groupBy:`, except the original order of the
 items is unchanged (this is particularly useful if the original collection
 is sorted).

 For example, with the array `@[@"foo", @"bar"]`, if we were to chunk by
 each item's first character:

    [@[@"foo", @"bar"] chunk:^(id string){
        return [string substringToIndex:1];
    }];
    // => @[
            @[@"f", @[@"foo"]],
            @[@"b", @[@"bar"]]
          ]

 Every "chunk" of items that returns the same value from the block is
 grouped together:

    [@[@"foo", @"bar", @"baz"] chunk:^(id string){
        return [string substringToIndex:1];
    }];
    // => @[
            @[@"f", @[@"foo"]],
            @[@"b", @[@"bar", @"baz"]]
          ]

 @param block A block whose return value will be used as a key to group
    the item by.
*/
- (NSArray *)chunk:(id (^)(id obj))block;

/**
 Accumulates a result by applying the block to each element in turn.
 Each time the block is executed, its return value becomes the new value
 of the accumulator.

 In this form of `reduce:`, as opposed to `reduce:withBlock:`, the first
 element of the collection will become the initial value of the
 accumulator, and every other element in the collection will be passed
 to the block in turn.

 For example, take an array of numbers for which we need to calculate
 the maximum:

    NSArray *numbers = @[@5, @1, @100, @13, @28, @123, @321, @10, @99, @4];

    // at each step, returns the new maximum
    [numbers reduce:^(id max, id num){
        return [num integerValue] > [max integerValue] ? num : max;
    }];
    // => @321

 1. The first element, `@5`, becomes the first value of `max`
 2. The block is called with `max = @5` and `num = @1`. `max` is still
    greater, so it is returned.
 3. The block is called with `max = @5` and `num = @100`. This time,
    `num` is greater, and so the block returns `@100`.
 4. The block is called with `max = @100` and `num = @13`. It returns
    `@100`.
 5. And so on, until the maximum value of `@321` is returned.

 @param block A block that accepts an accumulator value, and each
    successive object in the collection.

 @return The result of the transformation.
 */
- (id)reduce:(id (^)(id memo, id obj))block;

/**
 Accumulates a result by applying the block to each element in turn.
 Each time the block is executed, its return value becomes the new value
 of the accumulator. The final result may be a new collection or a
 discrete object.

 In a variation on the example in `reduce:`, instead of returning the
 maximum value in the array, we can instead return an array showing
 how the maximum value changed across the enumeration:

    NSArray *numbers = @[@5, @1, @100, @13, @28, @123, @321, @10, @99, @4];

    [numbers reduce:[numbers take:1] withBlock:^(id maximums, id num){
        if ([num integerValue] > [[maximums lastObject] integerValue]) {
            [maximums addObject:num];
        }
        return maximums;
    }];
    // => @[@5, @100, @123, @321]

 1. We use `[numbers take:1]` as the initial, which returns a new array
    containing the first number (`@[@5]`). At each step, we test if the
    number is greater than the last object in the array (the current
    maximum).
 2. For the first and second iterations, `maximums` is unchanged, as the
    max value hasn't increased yet.
 3. For `num = @100`, we have a new max value, so it is added to the
    array.
 4. And so on, until the final array of maximum numbers is copied and
    returned.

 @param initial The initial accumulator value to be passed to the block.
    If the object conforms to `NSMutableCopying`, a mutable copy of it
    will be taken, to allow for the construction of new collections.
    Passing `nil` causes the first element to become the initial value,
    and thus is equivalent to calling `reduce:`.

 @param block A block that accepts an accumulator value, and each
    successive object in the collection.

 @return The result of the transformation. This may be a new collection,
    or a discrete object. If the result conforms to `NSCopying`, it is
    copied first.
 */
- (id)reduce:(id)initial withBlock:(id (^)(id memo, id obj))block;

/**
 Accumulates a result by "injecting" the operation between successive
 pairs of elements.

 Usage:

    NSArray *letters = @[@"H", @"e", @"l", @"l", @"o"];

    [letters inject:@selector(stringByAppendingString:)];
    // => @"Hello"

 This is equivalent to the following, using `reduce:`:

    [letters reduce:^(id s, id letter){
        return [s stringByAppendingString:letter];
    }];
    // => @"Hello"

 @param binaryOperation A selector that takes a single parameter, and
    is expected to return an instance of the same type as the receiver.

 @return Returns the result of "injecting" the operation between each
    element of the collection.
 */
- (id)inject:(SEL)binaryOperation;

/**
 Given an initial value, accumulates a result by "injecting" the
 operation between successive pairs of elements.

 @deprecated Use `inject:` or `reduce:` instead.
 */
- (id)inject:(id)initial withOperation:(SEL)binaryOperation DEPRECATED_ATTRIBUTE;


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

/**
 Find the first element in a collection for which the block returns `YES`.

 Usage:

    NSArray *numbers = @[@1, @3, @5, @6, @9];

    // look for an even number
    [numbers find:^BOOL(id obj) {
        return [obj integerValue] % 2 == 0;
    }];
    // => @6

 @param block A block that accepts each successive object and returns
    a `BOOL` result.

 @return Returns the first object for which the block returns `YES`, if
    any. If no object is found, returns `nil`.
 */
- (id)find:(BOOL (^)(id obj))block;

/**
 Check if any value in a collection passes the block.

 Usage:

     NSArray *numbers = @[@1, @3, @5, @7, @9];

    // look for an even number
    [numbers any:^BOOL(id obj) {
        return [obj integerValue] % 2 == 0;
    }];
    // => @NO

 @param block A block that accepts each successive object and returns
    a `BOOL` result.

 @return Returns `YES` if an object is found for which the block returns `YES`.
    If no object is found, returns `NO`.
 */
- (BOOL)any:(BOOL (^)(id obj))block;

/**
 Check if all values in a collection pass the block.

 Usage:

     NSArray *numbers = @[@1, @3, @5, @7, @9];

    // Check if all numbers are odd
    [numbers all:^BOOL(id obj) {
        return [obj integerValue] % 2 != 0;
    }];
    // => @YES

 @param block A block that accepts each successive object and returns
    a `BOOL` result.

 @return Returns `YES` if the block returns `YES` for all objects in the
    collection. If the block returns `NO` for at least one object, returns `NO`.
 */
- (BOOL)all:(BOOL (^)(id obj))block;


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
