#import <Kiwi.h>
#import "NSSet+EKEnumerable.h"

SPEC_BEGIN(EKEnumerableNSSetSpec)

describe(@"-initWithEnumerable:", ^{

    it(@"constructs a set containing each enumerated value", ^{
        NSArray *values = @[@1, @2, @3];
        NSSet *set = [[NSSet alloc] initWithEnumerable:values];
        [[set should] equal:[NSSet setWithArray:@[@1, @2, @3]]];
    });

});

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
