#import <Kiwi/Kiwi.h>
#import "EKSemaphore.h"

SPEC_BEGIN(EKSemaphoreSpec)

describe(@"EKSemaphore", ^{

    __block EKSemaphore *sem;
    __block NSOperationQueue *queue;
    beforeEach(^{
        sem = [EKSemaphore new];
        queue = [NSOperationQueue new];
    });

    describe(@"-init", ^{
        specify(^{
            [[theValue([EKSemaphore new].value) should] equal:theValue(0)];
        });
    });

    it(@"resumes execution when signalled", ^{
        __block NSNumber *executionState = @0;
        [queue addOperationWithBlock:^{
            executionState = @1;
            [sem wait];
            executionState = @2;
        }];

        [[expectFutureValue(executionState) shouldEventually] equal:@1];
        [sem signal];
        [[expectFutureValue(executionState) shouldEventually] equal:@2];
    });

    it(@"times out if not signalled", ^{
        __block BOOL waitSuccess = YES;
        [queue addOperationWithBlock:^{
            waitSuccess = [sem waitForTimeInterval:0.1];
        }];

        [[expectFutureValue(theValue(waitSuccess)) shouldEventually] beNo];
    });

    it(@"doesn't time out if signalled", ^{
        __block BOOL waitSuccess = NO;
        [queue addOperationWithBlock:^{
            waitSuccess = [sem waitForTimeInterval:0.1];
        }];

        [sem signal];
        [[expectFutureValue(theValue(waitSuccess)) shouldEventually] beYes];
    });

    it(@"blocks when the semaphore count is exceeded", ^{
        EKSemaphore *countedSem = [EKSemaphore semaphoreWithValue:2];

        NSMutableArray *finishedFlags = @[@NO, @NO, @NO].mutableCopy;
        NSOperation *firstOperation = [NSBlockOperation blockOperationWithBlock:^{
            [countedSem wait];
            finishedFlags[0] = @YES;
        }];
        NSOperation *secondOperation = [NSBlockOperation blockOperationWithBlock:^{
            [countedSem wait];
            finishedFlags[1] = @YES;
        }];
        NSOperation *thirdOperation = [NSBlockOperation blockOperationWithBlock:^{
            // as the semaphore value is 2, this will block until the
            // semaphore is signalled
            [countedSem wait];

            finishedFlags[2] = @YES;

            // this operation needs to clean up after the other two or
            // we crash when EKSemaphore is deallocated
            [countedSem signal];
            [countedSem signal];
        }];

        [firstOperation start];
        [secondOperation start];
        [queue addOperation:thirdOperation]; // execute the third operation asynchronously

        // wait here until the third operation starts executing
        [[expectFutureValue(theValue(thirdOperation.isExecuting)) shouldEventually] beYes];

        // third operation has now started, but will not finish until
        // the semaphore is signalled
        [[finishedFlags should] equal:@[@YES, @YES, @NO]];

        [countedSem signal];
        [[expectFutureValue(finishedFlags) shouldEventually] equal:@[@YES, @YES, @YES]];
    });

});

SPEC_END
