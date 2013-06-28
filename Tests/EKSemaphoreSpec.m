#import <Kiwi.h>
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

    it(@"allows multiple threads to wait", ^{
        EKSemaphore *countedSem = [EKSemaphore semaphoreWithValue:2];

        NSMutableArray *startedFlags = @[@NO, @NO, @NO].mutableCopy;
        NSMutableArray *finishedFlags = @[@NO, @NO, @NO].mutableCopy;
        [queue addOperationWithBlock:^{
            startedFlags[0] = @YES;
            [countedSem wait];
            finishedFlags[0] = @YES;
        }];
        [queue addOperationWithBlock:^{
            startedFlags[1] = @YES;
            [countedSem wait];
            finishedFlags[1] = @YES;
        }];

        NSOperation *thirdOperation = [NSBlockOperation blockOperationWithBlock:^{
            startedFlags[2] = @YES;
            [[startedFlags should] equal:@[@YES, @YES, @YES]];

            // as the semaphore value is 2, this will block until the
            // semaphore is signalled
            [countedSem wait];

            finishedFlags[2] = @YES;

            // this operation needs to clean up after the other two or
            // we crash when EKSemaphore is deallocated
            [countedSem signal];
            [countedSem signal];
        }];
        [queue addOperation:thirdOperation];

        // wait here until the third operation starts executing
        while (!thirdOperation.isExecuting) continue;

        // third operation has now started, but will not finish until
        // the semaphore is signalled
        [[finishedFlags should] equal:@[@YES, @YES, @NO]];

        [countedSem signal];
        [[expectFutureValue(finishedFlags) shouldEventually] equal:@[@YES, @YES, @YES]];
    });

});

SPEC_END
