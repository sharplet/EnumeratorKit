//
//  Fiber.m
//  FakeEnumerable
//
//  Created by Adam Sharp on 17/05/13.
//
//

#import "Fiber.h"




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





@interface Fiber ()

+ (NSString *)register:(Fiber *)fiber;
+ (void)removeFiber:(Fiber *)fiber;

- (void)executeBlock;

@property (nonatomic, copy) id (^block)(void);
@property (nonatomic, strong) NSString *label;

@property (nonatomic) BOOL blockStarted;
@property (nonatomic) id blockResult;

@property (nonatomic) SerialOperationQueue *queue;
@property (nonatomic) dispatch_semaphore_t resumeSemaphore;
@property (nonatomic) dispatch_semaphore_t yieldSemaphore;

@end

@implementation Fiber

static NSMutableDictionary *fibers;
static SerialOperationQueue *fibersQueue;

+ (NSString *)register:(Fiber *)fiber
{
    // fibersQueue synchronises fiber creation and deletion
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fibers = [NSMutableDictionary new];
        fibersQueue = [SerialOperationQueue new];
    });

    // register the new fiber
    __block id label;
    [fibersQueue addOperationWithBlockAndWait:^{
        static NSUInteger fiberCounter = 0;
        label = [NSString stringWithFormat:@"fiber.%d", fiberCounter++];
        fibers[label] = fiber;
    }];

    return label;
}

+ (instancetype)current
{
    return fibers[[[NSOperationQueue currentQueue] name]];
}

+ (void)removeFiber:(Fiber *)fiber
{
    [fibersQueue addOperationWithBlockAndWait:^{
        [fibers removeObjectForKey:fiber.label];
    }];
}

+ (void)yield:(id)obj
{
    [[Fiber current] yield:obj];
}

+ (instancetype)fiberWithBlock:(id (^)(void))block
{
    return [[self alloc] initWithBlock:block];
}

- (id)initWithBlock:(id (^)(void))block
{
    if (self = [super init]) {
        // register with the global fiber list -- this synchronises
        // fiber creation
        _label = [Fiber register:self];

        _block = [block copy];
        _blockStarted = NO;

        // set up the fiber's queue and control semaphores
        _queue = [SerialOperationQueue new];
        _queue.name = self.label;
        _resumeSemaphore = dispatch_semaphore_create(0);
        _yieldSemaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)executeBlock
{
    self.blockStarted = YES;

    [self.queue addOperationWithBlock:^{
        self.blockResult = self.block();
        self.blockStarted = NO;

        // clean up
        [Fiber removeFiber:self];
        self.block = nil;

        dispatch_semaphore_signal(self.yieldSemaphore);
    }];
}

- (id)resume
{
    // if we are ever resumed and we don't have a block, the fiber is
    // dead, so raise an exception
    if (!self.isAlive) {
        [NSException raise:@"FiberException" format:@"dead fiber called"];
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

- (void)yield:(id)obj
{
    self.blockResult = obj;
    dispatch_semaphore_signal(self.yieldSemaphore);
    dispatch_semaphore_wait(self.resumeSemaphore, DISPATCH_TIME_FOREVER);
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
