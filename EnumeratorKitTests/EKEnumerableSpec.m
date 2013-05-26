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

describe(@"-map", ^{

    context(@"message style", ^{

        it(@"returns an array with the mapped elements", ^{
            id strings = [@[@1,@2,@3] map:^(id obj){
                return [NSString stringWithFormat:@"%@", obj];
            }];

            [[strings should] equal:@[@"1", @"2", @"3"]];
        });

    });

    context(@"function style", ^{

        it(@"returns an array with the mapped elements", ^{
            id strings = @[@1,@2,@3].map(^(id obj){
                return [NSString stringWithFormat:@"%@", obj];
            });

            [[strings should] equal:@[@"1", @"2", @"3"]];
        });

    });

});

SPEC_END
