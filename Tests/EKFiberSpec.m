#import <Kiwi/Kiwi.h>
#import "EKFiber.h"

SPEC_BEGIN(EKFiberSpec)

describe(@"-resume", ^{

    context(@"with no yield statements", ^{
        __block EKFiber *fiber;
        id (^noYieldBlock)(void) = ^id{
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
            EKFiber *fiber = [EKFiber fiberWithBlock:^id{
                [EKFiber yield:@1];
                return @2;
            }];

            [[fiber.resume should] equal:@1];
            [[fiber.resume should] equal:@2];
        });

    });

});

SPEC_END
