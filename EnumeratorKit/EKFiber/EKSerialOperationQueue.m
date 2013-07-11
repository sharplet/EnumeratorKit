//
//  EKSerialOperationQueue.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 27/06/13.
//
//

#import "EKSerialOperationQueue.h"

@implementation EKSerialOperationQueue

- (id)init
{
    if (self = [super init]) {
        super.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)setMaxConcurrentOperationCount:(NSInteger)cnt
{
    // no-op: queue must be a serial queue
}

- (void)addOperationWithBlockAndWait:(void (^)(void))block
{
    id operation = [NSBlockOperation blockOperationWithBlock:block];
    [self addOperations:@[operation] waitUntilFinished:YES];
}

@end
