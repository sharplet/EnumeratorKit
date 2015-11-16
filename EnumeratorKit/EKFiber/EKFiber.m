//
//  EKFiber.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 17/05/13.
//
//

#import "EKFiber.h"
#import "EKSemaphore.h"
#import "EKSerialOperationQueue.h"

@interface EKFiber () <EKYielder>

- (void)executeBlock;

@property (nonatomic, copy) id (^block)(id<EKYielder>);
@property (nonatomic, weak) NSBlockOperation *blockOperation;

@property (nonatomic) BOOL blockStarted;
@property (nonatomic) id blockResult;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) EKSemaphore *resumeSemaphore;
@property (nonatomic, strong) EKSemaphore *yieldSemaphore;

@end

@implementation EKFiber

+ (NSOperationQueue *)queue {
    static NSOperationQueue *queue;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        queue = [NSOperationQueue new];
        queue.name = @"com.sharplet.enumeratorkit.fiber";
    });
    return queue;
}

+ (instancetype)fiberWithBlock:(id (^)(id<EKYielder>))block
{
    return [[EKFiber alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id (^)(id<EKYielder>))block
{
    if (self = [super init]) {
        _block = [block copy];
        _blockStarted = NO;

        // set up the fiber's queue and control semaphores
        _queue = self.class.queue;
        _resumeSemaphore = [EKSemaphore new];
        _yieldSemaphore = [EKSemaphore new];
    }
    return self;
}

- (void)executeBlock
{
    self.blockStarted = YES;

    __weak EKFiber *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation new];
    [operation addExecutionBlock:^{
        EKFiber *self = weakSelf;

        if (!self.blockOperation.isCancelled) {
            self.blockResult = self.block(self);
            self.blockStarted = NO;

            // clean up
            [self destroy];
            self.block = nil;

            [self.yieldSemaphore signal];
        }
    }];

    self.blockOperation = operation;
    [self.queue addOperation:self.blockOperation];
}

- (id)resume
{
    // if we are ever resumed and we don't have a block, the fiber is
    // dead, so raise an exception
    if (!self.isAlive) {
        [NSException raise:@"EKFiberException" format:@"dead fiber called"];
    }
    else {
        // if the block has started, resume it, otherwise start executing it
        if (self.blockStarted) {
            [self.resumeSemaphore signal]; // fiber queue resumes
        }
        else {
            [self executeBlock];
        }
    }

    // wait until the fiber finishes or yields and return the result
    [self.yieldSemaphore wait];
    return self.blockResult;
}

- (void)destroy
{
    if (self.blockOperation) {
        [self.blockOperation cancel];
    }
}

- (void)yield:(id)obj
{
    self.blockResult = obj;
    [self.yieldSemaphore signal];

    // wait until -resume is called, only as long as the fiber hasn't
    // been cancelled
    while (!self.blockOperation.isCancelled) {

        // if the semaphore is signalled, break out of the loop so that
        // execution continues
        if ([self.resumeSemaphore waitForTimeInterval:0.02]) {
            break;
        }
    }
}

- (BOOL)isAlive
{
    return !!self.block;
}

@end
