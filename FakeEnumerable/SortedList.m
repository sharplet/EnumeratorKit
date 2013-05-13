//
//  SortedList.m
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "SortedList.h"
#import "FakeEnumerator.h"
#import "NSArray+FakeEnumerable.h"

@interface SortedList ()
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation SortedList

- (id)init
{
    if (self = [super init]) {
        _data = [NSMutableArray array];
    }
    return self;
}

- (instancetype)insert:(NSNumber *)object
{
    [self.data addObject:object];
    [self.data sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    return self;
}

- (id)each
{
    return [[FakeEnumerator alloc] initWithTarget:self selector:@selector(each:)];
}

- (id)each:(void (^)(id))block
{
    return [self.data each:block];
}

@end
