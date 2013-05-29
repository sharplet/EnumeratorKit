//
//  NSObject+EKEnumerable.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 27/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKEnumerator.h"

@interface NSObject (EKEnumerator)

- (EKEnumerator *)asEnumerator;

@end
