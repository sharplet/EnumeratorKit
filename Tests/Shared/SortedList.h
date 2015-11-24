//
//  SortedList.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EnumeratorKit/EnumeratorKit.h>

@interface SortedList : NSObject <EKEnumerable>

- (instancetype)initWithArray:(NSArray *)array;

- (instancetype)insert:(NSNumber *)object;

@end
