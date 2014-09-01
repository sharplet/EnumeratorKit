#import <Kiwi.h>
#import "NSSet+EKEnumerable.h"

SPEC_BEGIN(EKEnumerableNSSetSpec)

describe(@"-each", ^{

    __block NSSet *set;
    beforeEach(^{
        set = [NSSet setWithArray:@[@1,@2,@3]];
    });

    it(@"enumerates over key-value pairs", ^{
        __block NSUInteger count = 0;
        [set each:^(id obj) {
            count++;
        }];
        [[theValue(count) should] equal:theValue(3)];
    });

});

SPEC_END
