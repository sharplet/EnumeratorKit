#import <Kiwi.h>
#import "NSArray+EKEnumerable.h"

SPEC_BEGIN(EKEnumerableSpec)

describe(@"-each", ^{

    context(@"message style", ^{

        it(@"performs the block once for each element", ^{
            __block int count = 0;

            [@[@1,@2,@3] each:^(id obj){
                count++;
            }];

            [[theValue(count) should] equal:theValue(3)];
        });

    });

    context(@"function style", ^{

        it(@"performs the block once for each element", ^{
            __block int count = 0;

            @[@1,@2,@3].each(^(id obj){
                count++;
            });

            [[theValue(count) should] equal:theValue(3)];
        });

    });

});

SPEC_END
