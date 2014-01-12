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

@interface EKFiber ()

+ (NSString *)register:(EKFiber *)fiber;
+ (void)removeFiber:(EKFiber *)fiber;

- (void)executeBlock;

@property (nonatomic, copy) id (^block)(void);
@property (nonatomic, unsafe_unretained) NSBlockOperation *blockOperation;
@property (nonatomic, strong) NSString *label;

@property (nonatomic) BOOL blockStarted;
@property (nonatomic) id blockResult;

@property (nonatomic, strong) EKSerialOperationQueue *queue;
@property (nonatomic, strong) EKSemaphore *resumeSemaphore;
@property (nonatomic, strong) EKSemaphore *yieldSemaphore;

@end

@implementation EKFiber

static NSMutableDictionary *fibers;
static EKSerialOperationQueue *fibersQueue;

+ (NSString *)register:(EKFiber *)fiber
{
    // fibersQueue synchronises fiber creation and deletion
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fibers = [NSMutableDictionary new];
        fibersQueue = [EKSerialOperationQueue new];
    });

    // register the new fiber
    __block id label;
    [fibersQueue addOperationWithBlockAndWait:^{
        static unsigned int fiberCounter = 0;
        label = [NSString stringWithFormat:@"fiber.%d", fiberCounter++];
        fibers[label] = fiber;
    }];

    return label;
}

+ (instancetype)current
{
    return fibers[[[NSOperationQueue currentQueue] name]];
}

+ (void)removeFiber:(EKFiber *)fiber
{
    [fibersQueue addOperationWithBlockAndWait:^{
        [fiber.queue cancelAllOperations];
        [fibers removeObjectForKey:fiber.label];
    }];
}

+ (void)yield:(id)obj
{
    [[EKFiber current] yield:obj];
}

+ (instancetype)fiberWithBlock:(id (^)(void))block
{
    return [[EKFiber alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id (^)(void))block
{
    if (self = [super init]) {
        // register with the global fiber list -- this synchronises
        // fiber creation
        _label = [EKFiber register:self];

        _block = [block copy];
        _blockStarted = NO;

        // set up the fiber's queue and control semaphores
        _queue = [EKSerialOperationQueue new];
        _queue.name = self.label;
        _resumeSemaphore = [EKSemaphore new];
        _yieldSemaphore = [EKSemaphore new];
    }
    return self;
}

- (void)executeBlock
{
    self.blockStarted = YES;

    __unsafe_unretained EKFiber *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation new];
    [operation addExecutionBlock:^{
        if (!self.blockOperation.isCancelled) {
            weakSelf.blockResult = weakSelf.block();
            weakSelf.blockStarted = NO;

            // clean up
            [EKFiber removeFiber:weakSelf];
            weakSelf.block = nil;

            [weakSelf.yieldSemaphore signal];
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
    [EKFiber removeFiber:self];
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
    return (self.block != nil);
}

@end
