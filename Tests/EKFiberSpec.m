#import <Kiwi/Kiwi.h>
#import "EKFiber.h"

SPEC_BEGIN(EKFiberSpec)

describe(@"-resume", ^{

    context(@"with no yield statements", ^{
        __block EKFiber *fiber;
        void (^noYieldBlock)(id<EKYielder>) = ^(id<EKYielder> yielder){};

        beforeEach(^{
            fiber = [EKFiber fiberWithBlock:noYieldBlock];
        });

        it(@"returns the block's return value", ^{
            [[[fiber resume] should] beNil];
        });
    });

    context(@"with a single yield", ^{
        it(@"returns the yielded value, then the block return value", ^{
            EKFiber *fiber = [EKFiber fiberWithBlock:^(id<EKYielder> yielder){
                [yielder yield:@1];
            }];

            [[[fiber resume] should] equal:@1];
        });
    });

    context(@"with multiple yields", ^{
        it(@"returns all the yielded values, then nil", ^{
            EKFiber *fiber = [EKFiber fiberWithBlock:^(id<EKYielder> yielder){
                [yielder yield:@1];
                [yielder yield:@2];
                [yielder yield:@3];
            }];

            [[[fiber resume] should] equal:@1];
            [[[fiber resume] should] equal:@2];
            [[[fiber resume] should] equal:@3];
            [[[fiber resume] should] beNil];
        });
    });

    context(@"performance", ^{
        it(@"can manage a high number of concurrent fibers", ^{
            for (int i = 0; i < 100; i++) {
                EKFiber *fiber = [EKFiber fiberWithBlock:^(id<EKYielder> yielder) {
                    [yielder yield:@1];
                    [yielder yield:@2];
                }];
                [[[fiber resume] should] equal:@1];
            }
        });
    });

});

SPEC_END
