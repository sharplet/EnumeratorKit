#import <Kiwi.h>
#import "NSArray+EKEnumerable.h"

SPEC_BEGIN(EKEnumerableSpec)

describe(@"-map", ^{

    it(@"returns an EKEnumerator", ^{
        id result = @[].map;
        [[result should] beKindOfClass:[EKEnumerator class]];
    });

    describe(@"the enumerator", ^{
        it(@"iterates over the unmapped collection", ^{
            id iterated = [@[@"foo"].map each:^(id obj){}];
            [[iterated should] equal:@[@"foo"]];
        });
    });

});

SPEC_END
