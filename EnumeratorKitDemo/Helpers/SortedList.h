//
//  SortedList.h
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FakeEnumerable.h"
#import "NSNumber+BinaryOperations.h"

@interface SortedList : NSObject <FakeEnumerable>

- (instancetype)insert:(NSNumber *)object;

@end
