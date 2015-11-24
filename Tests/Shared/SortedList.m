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

- (instancetype)each:(void (^)(id))block
{
    [self.data each:block];
    return self;
}

@end
