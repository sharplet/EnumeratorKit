//
//  SortedList.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "SortedList.h"

@interface SortedList ()
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation SortedList

+ (void)load
{
    [self includeEKEnumerable];
}

- (instancetype)initWithArray:(NSArray *)array
{
    NSParameterAssert(array != nil);

    if (self = [super init]) {
        _data = [[array sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    }
    return self;
}

- (id)init
{
    return [self initWithArray:@[]];
}

- (instancetype)initWithEnumerable:(id<EKEnumerable>)enumerable
{
    return [self initWithArray:[enumerable asArray]];
}

- (instancetype)insert:(NSNumber *)object
{
    [self.data addObject:object];
    [self.data sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    return self;
}

- (instancetype)each:(void (^)(id))block
{
    [self.data each:block];
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[SortedList class]]) {
        return [self isEqualToSortedList:object];
    }
    else {
        return NO;
    }
}

- (BOOL)isEqualToSortedList:(SortedList *)sortedList
{
    return [self.data isEqualToArray:sortedList.data];
}

- (NSUInteger)hash
{
    return self.data.hash;
}

@end
