#import <Kiwi.h>
#import "RFFiber.h"

SPEC_BEGIN(RFFiberSpec)

describe(@"-resume", ^{

    context(@"with no yield statements", ^{
        __block RFFiber *fiber;
        id (^noYieldBlock)(void) = ^id{
            return @"foo";
        };

        beforeEach(^{
            fiber = [RFFiber fiberWithBlock:noYieldBlock];
        });

        it(@"returns the block's return value", ^{
            [[fiber.resume should] equal:@"foo"];
        });

        it(@"raises a dead fiber error if resumed a second time", ^{
            (void)fiber.resume;
            [[theBlock(^{ (void)fiber.resume; }) should] raiseWithName:@"RFFiberException"];
        });

    });

    context(@"with a single yield", ^{

        it(@"returns the yielded value, then the block return value", ^{
            RFFiber *fiber = [RFFiber fiberWithBlock:^id{
                [RFFiber yield:@1];
                return @2;
            }];

            [[fiber.resume should] equal:@1];
            [[fiber.resume should] equal:@2];
        });

    });

});

SPEC_END
