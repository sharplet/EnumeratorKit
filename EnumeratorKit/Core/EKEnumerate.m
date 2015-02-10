//
//  EKEnumerate.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 7/02/2015.
//  Copyright (c) 2015 Adam Sharp. All rights reserved.
//

#import "EKEnumerate.h"
#import "EKEnumerator.h"

EKEnumerator *ek_enumerate(id<NSFastEnumeration> enumeration) {
    return [EKEnumerator new:^(id<EKYielder> y) {
        for (id i in enumeration) {
            [y yield:i];
        }
    }];
}
