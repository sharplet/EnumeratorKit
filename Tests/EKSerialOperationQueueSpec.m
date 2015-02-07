#import <Kiwi/Kiwi.h>
#import "EKSerialOperationQueue.h"

SPEC_BEGIN(EKSerialOperationQueueSpec)

describe(@"EKSerialOperationQueue", ^{

    __block NSOperationQueue *serialQueue;
    beforeEach(^{
        serialQueue = [EKSerialOperationQueue new];
    });

    specify(^{
        [[theValue(serialQueue.maxConcurrentOperationCount) should] equal:theValue(1)];
    });

    it(@"doesn't allow maxConcurrentOperationCount to be overridden", ^{
        serialQueue.maxConcurrentOperationCount = 500;
        [[theValue(serialQueue.maxConcurrentOperationCount) should] equal:theValue(1)];
    });

    it(@"only executes one operation at a time", ^{
        dispatch_semaphore_t longRunningOperationStarted = dispatch_semaphore_create(0);

        NSOperation *longRunningOperation = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_semaphore_signal(longRunningOperationStarted);
            [NSThread sleepForTimeInterval:0.3];
        }];
        NSOperation *shortOperation = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:0.1];
        }];

        [[theValue(shortOperation.isExecuting) should] beNo];

        [serialQueue addOperation:longRunningOperation];
        [serialQueue addOperation:shortOperation];

        dispatch_semaphore_wait(longRunningOperationStarted, DISPATCH_TIME_FOREVER);
        [[theValue(longRunningOperation.isExecuting) should] beYes];
        [[theValue(shortOperation.isExecuting) should] beNo];
        [[expectFutureValue(theValue(shortOperation.isFinished)) shouldEventuallyBeforeTimingOutAfter(1.0)] beYes];
    });

});

SPEC_END
