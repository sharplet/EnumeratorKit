//
//  EKEnumerate.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 7/02/2015.
//  Copyright (c) 2015 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKEnumerator.h"

/**
 Wraps a collection conforming to NSFastEnumeration in an EKEnumerator that
 yields each object in turn, providing quick access to the entire EKEnumerable
 API.

 Example:

    [ek_enumerate(@[@1, @2, @3]) map:^(NSNumber *i) {
        return @(i.integerValue * 2);
    }];
    // => @[@2, @4, @6]

 @param enumeration An object conforming to the NSFastEnumeration protocol.
 */
EKEnumerator *ek_enumerate(id<NSFastEnumeration> enumeration);
