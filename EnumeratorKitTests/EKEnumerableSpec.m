#import <Kiwi.h>
#import "NSArray+EKEnumerable.h"
#import "NSNumber+BinaryOperations.h"

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

describe(@"-reduce", ^{

    context(@"message style", ^{

        it(@"uses the first element in the collection if no initial is provided", ^{
            id total = [@[@1,@2,@3] reduce:^(id m, id i){
                return [m add:i];
            }];
            [[total should] equal:@6];
        });

        it(@"uses the initial if provided", ^{
            id total = [@[@2,@3] reduce:@1 withBlock:^(id m, id i){
                return [m add:i];
            }];
            [[total should] equal:@6];
        });

    });

    context(@"function style", ^{

        it(@"uses the first element in the collection if no initial is provided", ^{
            id total = @[@1,@2,@3].reduce(^(id m, id i){
                return [m add:i];
            });
            [[total should] equal:@6];
        });

        it(@"uses the initial if provided", ^{
            id total = @[@2,@3].reduce(@1, ^(id m, id i){
                return [m add:i];
            });
            [[total should] equal:@6];
        });

    });

});

SPEC_END
