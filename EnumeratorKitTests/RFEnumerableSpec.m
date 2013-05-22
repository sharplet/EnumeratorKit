#import <Kiwi.h>
#import "NSArray+RFEnumerable.h"

SPEC_BEGIN(RFEnumerableSpec)

describe(@"-map", ^{

    it(@"returns an RFEnumerator", ^{
        id result = @[].map;
        [[result should] beKindOfClass:[RFEnumerator class]];
    });

    describe(@"the enumerator", ^{
        it(@"iterates over the unmapped collection", ^{
            id iterated = [@[@"foo"].map each:^(id obj){}];
            [[iterated should] equal:@[@"foo"]];
        });
    });

});

SPEC_END
