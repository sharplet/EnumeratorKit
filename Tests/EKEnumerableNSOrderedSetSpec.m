#import <Kiwi.h>
#import "NSOrderedSet+EKEnumerable.h"

SPEC_BEGIN(EKEnumerableNSOrderedSetSpec)

describe(@"-each", ^{

    __block NSOrderedSet *set;
    beforeEach(^{
        set = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
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
