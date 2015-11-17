#import <Kiwi/Kiwi.h>
#import "EKFiber.h"

SPEC_BEGIN(EKFiberSpec)

describe(@"-resume", ^{

    context(@"with no yield statements", ^{
        __block EKFiber *fiber;
        id (^noYieldBlock)(id<EKYielder>) = ^id(id<EKYielder> yielder){
            return @"foo";
        };

        beforeEach(^{
            fiber = [EKFiber fiberWithBlock:noYieldBlock];
        });

        it(@"returns the block's return value", ^{
            [[fiber.resume should] equal:@"foo"];
        });

        it(@"raises a dead fiber error if resumed a second time", ^{
            (void)fiber.resume;
            [[theBlock(^{ (void)fiber.resume; }) should] raiseWithName:@"EKFiberException"];
        });

    });

    context(@"with a single yield", ^{

        it(@"returns the yielded value, then the block return value", ^{
            EKFiber *fiber = [EKFiber fiberWithBlock:^id(id<EKYielder> yielder){
                [yielder yield:@1];
                return @2;
            }];

            [[fiber.resume should] equal:@1];
            [[fiber.resume should] equal:@2];
        });

    });

    context(@"performance", ^{
        it(@"can manage a high number of concurrent fibers", ^{
            for (int i = 0; i < 100; i++) {
                EKFiber *fiber = [EKFiber fiberWithBlock:^id(id<EKYielder> yielder) {
                    [yielder yield:@1];
                    [yielder yield:@2];
                    return nil;
                }];
                [[[fiber resume] should] equal:@1];
            }
        });
    });

});

SPEC_END
