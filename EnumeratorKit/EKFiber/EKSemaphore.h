//
//  EKSemaphore.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 27/06/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A simple object-oriented wrapper for GCD semaphores. Removes the need
 to manage creation and disposal of `dispatch_semaphore_t` objects, and
 provides convenient methods that map to `dispatch_semaphore_wait()` and
 `dispatch_semaphore_signal()`.

 For example:

     EKSemaphore *sem = [[EKSemaphore alloc] init];

     // the default is to wait forever, until the semaphore becomes available
     [sem wait];
     // do some work
     [sem signal]; // signal that you're done

     // you can time out if the resource doesn't become available
     if ([sem waitForTimeInterval:1.0]) {
         // successful wait, do some work
     }
     else {
         // timed out after 1 second
     }

 See the [GCD Reference](https://developer.apple.com/library/mac/#documentation/Performance/Reference/GCD_libdispatch_Ref/Reference/reference.html)
 for more info.
 */
@interface EKSemaphore : NSObject

#pragma mark Initialisers

/**
 Creates and returns an `EKSemaphore` with the specified value.

 @param value The count value of the semaphore, i.e., the number of
    concurrent waits before the semaphore blocks.
 */
+ (instancetype)semaphoreWithValue:(NSUInteger)value;

/**
 Designated initialiser. Create a new counting semaphore with the
 specified value.

 @param value The count value of the semaphore, i.e., the number of
    concurrent waits before the semaphore blocks.
 */
- (instancetype)initWithValue:(NSUInteger)value;

/**
 This convenience initialiser creates a binary semaphore (value 0).
 */
- (id)init;

#pragma mark Semaphore operations

/**
 Cause the sender to wait on the semaphore until it becomes available
 (i.e., `DISPATCH_TIME_FOREVER`).
 */
- (void)wait;

/**
 Wait on the semaphore, but time out after the specified time interval.

 @param timeInterval The time interval to wait before timing out, in seconds.
 @return `YES` if the wait was successful, or `NO` if waiting timed out.
 */
- (BOOL)waitForTimeInterval:(NSTimeInterval)timeInterval;

/**
 Signal that work with the semaphore is complete. For example, if you
 were making use of a finite resource represented by the semaphore, you
 should call `-signal` when you are finished with the resource.
 */
- (void)signal;

#pragma mark Properties

/**
 The value of the counting semaphore. A value of 0 or 1 indicates a
 binary semaphore, which behaves like a lock.
 */
@property (nonatomic, readonly) NSUInteger value;

@end
