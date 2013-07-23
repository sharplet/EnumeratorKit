#include <Kiwi.h>
#import "NSArray+EKFlatten.h"

SPEC_BEGIN(NSArrayEKFlattenSpec)

describe(@"EKFlatten", ^{

    it(@"returns self if the array is flat", ^{
        NSArray *array = @[@1,@2,@3];
        [[[array flatten] should] beIdenticalTo:array];
    });

    it(@"flattens a 2D array", ^{
        NSArray *array = @[@[@1, @2], @3];
        [[[array flatten] should] equal:@[@1, @2, @3]];
    });

    it(@"flattens a 3D array", ^{
        NSArray *array = @[@1, @[@2, @[@3, @4]], @5, @[@6]];
        [[[array flatten] should] equal:@[@1, @2, @3, @4, @5, @6]];
    });

});

SPEC_END
