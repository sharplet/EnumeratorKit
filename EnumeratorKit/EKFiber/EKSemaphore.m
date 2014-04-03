//
//  EKSemaphore.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 27/06/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "EKSemaphore.h"

@interface EKSemaphore ()
@property (nonatomic) dispatch_semaphore_t semaphore;
@end

@implementation EKSemaphore

#pragma mark Initialisers

+ (instancetype)semaphoreWithValue:(NSUInteger)value
{
    return [[EKSemaphore alloc] initWithValue:value];
}

- (instancetype)initWithValue:(NSUInteger)value
{
    if (self = [super init]) {
        _value = value;
        _semaphore = dispatch_semaphore_create(value);
    }
    return self;
}

- (id)init
{
    return [self initWithValue:0];
}

#pragma mark Semaphore operations

- (void)signal
{
    dispatch_semaphore_signal(self.semaphore);
}

- (void)wait
{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)waitForTimeInterval:(NSTimeInterval)timeInterval
{
    dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC));
    long result = dispatch_semaphore_wait(self.semaphore, waitTime);
    return (result == 0);
}

@end
