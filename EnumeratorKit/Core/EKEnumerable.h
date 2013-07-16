//
//  EKEnumerable.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>

// block types
typedef void (^EKVisitor)(id obj);
typedef void (^EKIndexedVisitor)(id obj, NSUInteger i);
typedef BOOL (^EKPredicate)(id obj);
typedef id (^EKMapping)(id obj);
typedef id<NSCopying> (^EKKeyMapping)(id obj);


@protocol EKEnumerable <NSObject>

@required
- (id<EKEnumerable>)each:(EKVisitor)block;

@optional
- (id<EKEnumerable> (^)(EKVisitor))each;

- (id<EKEnumerable>)eachWithIndex:(EKIndexedVisitor)block;
- (id<EKEnumerable> (^)(EKIndexedVisitor))eachWithIndex;

- (NSArray *)asArray;
- (NSArray *)take:(NSInteger)number;
- (NSArray * (^)(NSInteger))take;

- (NSArray *)map:(EKMapping)block;
- (NSArray * (^)(EKMapping))map;

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
- (NSDictionary * (^)(EKKeyMapping))chunk;

- (NSArray *)select:(EKPredicate)block;
- (NSArray * (^)(EKPredicate))select;

- (NSArray *)filter:(EKPredicate)block;
- (NSArray * (^)(EKPredicate))filter;

- (NSArray *)reject:(EKPredicate)block;
- (NSArray * (^)(EKPredicate))reject;

- (NSArray *)sort;
- (NSArray *)sortWith:(NSComparator)comparator;
- (NSArray * (^)(NSComparator))sortWith;

- (NSArray *)sortBy:(EKMapping)block;
- (NSArray * (^)(EKMapping))sortBy;

- (id)find:(EKPredicate)block;
- (id (^)(EKPredicate))find;

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
