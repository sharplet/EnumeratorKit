//
//  EKFiber.m
//  EnumeratorKit
//
//  Created by Adam Sharp on 17/05/13.
//
//

#import "EKFiber.h"




@interface SerialOperationQueue : NSOperationQueue
- (void)addOperationWithBlockAndWait:(void (^)(void))block;
@end

@implementation SerialOperationQueue

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




@interface EKNamedBlockOperation : NSBlockOperation
@property (nonatomic, strong) NSString *name;
@end

@implementation EKNamedBlockOperation

@end




@interface EKFiber ()

+ (void)register:(EKFiber *)fiber;
+ (void)removeFiber:(EKFiber *)fiber;

- (void)executeBlock;

@property (nonatomic, copy) id (^block)(void);
@property (nonatomic, unsafe_unretained) EKNamedBlockOperation *blockOperation;
@property (nonatomic, strong) NSString *label;

@property (nonatomic) BOOL blockStarted;
@property (nonatomic) id blockResult;

@property (nonatomic) dispatch_semaphore_t resumeSemaphore;
@property (nonatomic) dispatch_semaphore_t yieldSemaphore;

@end

@implementation EKFiber

static NSMutableDictionary *fibers;
static NSMutableDictionary *fiberThreads;
static SerialOperationQueue *fiberSetupQueue;
static NSOperationQueue *fiberExecutionQueue;

+ (void)initialize
{
    // fibersQueue synchronises fiber creation and deletion
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fibers = [NSMutableDictionary new];
        fiberSetupQueue = [SerialOperationQueue new];
        fiberExecutionQueue = [SerialOperationQueue new];
    });
}

+ (void)register:(EKFiber *)fiber
{
    // register the new fiber
    __weak NSThread *fiberThread = [NSThread currentThread];
    [fiberSetupQueue addOperationWithBlockAndWait:^{
        static unsigned int fiberCounter = 0;
        fiber.label = [NSString stringWithFormat:@"fiber.%d", fiberCounter++];
        fibers[fiber.label] = fiber;
    }];
}

+ (instancetype)current
{
    return fibers[[[NSOperationQueue currentQueue] name]];
}

+ (void)removeFiber:(EKFiber *)fiber
{
    [fiberSetupQueue addOperationWithBlockAndWait:^{
        if (fiber.blockOperation.isExecuting) {
            [fiber.blockOperation cancel];
        }
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

- (id)initWithBlock:(id (^)(void))block
{
    if (self = [super init]) {
        _block = [block copy];
        _blockStarted = NO;

        // set up the fiber's control semaphores
        _resumeSemaphore = dispatch_semaphore_create(0);
        _yieldSemaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)executeBlock
{
    self.blockStarted = YES;

    __unsafe_unretained EKFiber *weakSelf = self;
    EKNamedBlockOperation *operation = [EKNamedBlockOperation new];
    self.blockOperation = operation;

    [self.blockOperation addExecutionBlock:^{
        if (!weakSelf.blockOperation.isCancelled) {
            // register with the global fiber list
            [EKFiber register:weakSelf];
            weakSelf.blockOperation.name = weakSelf.label;

            // execute the block
            weakSelf.blockResult = weakSelf.block();
            weakSelf.blockStarted = NO;

            // clean up
            [EKFiber removeFiber:weakSelf];
            weakSelf.block = nil;

            dispatch_semaphore_signal(weakSelf.yieldSemaphore);
        }
    }];

    [fiberExecutionQueue addOperation:self.blockOperation];
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
            dispatch_semaphore_signal(self.resumeSemaphore); // fiber queue resumes
        }
        else {
            [self executeBlock];
        }
    }

    // wait until the fiber finishes or yields and return the result
    dispatch_semaphore_wait(self.yieldSemaphore, DISPATCH_TIME_FOREVER);
    return self.blockResult;
}

- (void)destroy
{
    [EKFiber removeFiber:self];
}

- (void)yield:(id)obj
{
    self.blockResult = obj;
    dispatch_semaphore_signal(self.yieldSemaphore);

    // wait until -resume is called, only as long as the fiber hasn't
    // been cancelled
    while (!self.blockOperation.isCancelled) {
        double delayInSeconds = 0.02;
        dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));

        // if the semaphore is signalled, break out of the loop so that
        // execution continues
        if (!dispatch_semaphore_wait(self.resumeSemaphore, waitTime)) {
            break;
        }
    }
}

- (BOOL)isAlive
{
    return !!self.block;
}

- (void)dealloc
{
    dispatch_release(_resumeSemaphore);
    dispatch_release(_yieldSemaphore);
}

@end
