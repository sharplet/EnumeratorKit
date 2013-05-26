#import <Kiwi.h>
#import "Fiber.h"

SPEC_BEGIN(FiberSpec)

describe(@"-resume", ^{

    context(@"with no yield statements", ^{
        __block Fiber *fiber;
        id (^noYieldBlock)(void) = ^id{
            return @"foo";
        };

        beforeEach(^{
            fiber = [Fiber fiberWithBlock:noYieldBlock];
        });

        it(@"returns the block's return value", ^{
            [[fiber.resume should] equal:@"foo"];
        });

        it(@"raises a dead fiber error if resumed a second time", ^{
            (void)fiber.resume;
            [[theBlock(^{ (void)fiber.resume; }) should] raiseWithName:@"FiberException"];
        });

    });

    context(@"with a single yield", ^{

        it(@"returns the yielded value, then the block return value", ^{
            Fiber *fiber = [Fiber fiberWithBlock:^id{
                [Fiber yield:@1];
                return @2;
            }];

            [[fiber.resume should] equal:@1];
            [[fiber.resume should] equal:@2];
        });

    });

});

SPEC_END
