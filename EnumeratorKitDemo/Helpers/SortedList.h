//
//  SortedList.h
//  RFEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFEnumerable.h"
#import "NSNumber+BinaryOperations.h"

@interface SortedList : NSObject <RFEnumerable>

- (instancetype)insert:(NSNumber *)object;

@end
