#import <Kiwi.h>
#import "NSDictionary+EKEnumerable.h"

SPEC_BEGIN(NSDictionaryEKEnumerableSpec)

describe(@"-each", ^{

    context(@"message style", ^{

        it(@"enumerates over key-value pairs", ^{
            __block NSUInteger count = 0;
            [@{ @1: @"1", @2: @"2" } each:^(id obj) {
                count++;
                [[obj[0] should] beKindOfClass:[NSNumber class]];
                [[obj[1] should] beKindOfClass:[NSString class]];
            }];
            [[theValue(count) should] equal:theValue(2)];
        });

    });

    context(@"function style", ^{

        it(@"enumerates over key-value pairs", ^{
            __block NSUInteger count = 0;
            @{ @1: @"1", @2: @"2" }.each(^(id obj) {
                count++;
                [[obj[0] should] beKindOfClass:[NSNumber class]];
                [[obj[1] should] beKindOfClass:[NSString class]];
            });
            [[theValue(count) should] equal:theValue(2)];
        });

    });

});

describe(@"-eachPair", ^{

    context(@"message style", ^{

        it(@"enumerates over key-value pairs", ^{
            __block NSUInteger count = 0;
            [@{ @1: @"1", @2: @"2" } eachPair:^(id pair) {
                count++;
                [[pair[0] should] beKindOfClass:[NSNumber class]];
                [[pair[1] should] beKindOfClass:[NSString class]];
            }];
            [[theValue(count) should] equal:theValue(2)];
        });

    });

    context(@"function style", ^{

        it(@"enumerates over key-value pairs", ^{
            __block NSUInteger count = 0;
            @{ @1: @"1", @2: @"2" }.eachPair(^(id pair) {
                count++;
                [[pair[0] should] beKindOfClass:[NSNumber class]];
                [[pair[1] should] beKindOfClass:[NSString class]];
            });
            [[theValue(count) should] equal:theValue(2)];
        });

    });

});

describe(@"-eachEntry", ^{

    context(@"message style", ^{

        it(@"enumerates over key-value pairs", ^{
            __block NSUInteger count = 0;
            [@{ @1: @"1", @2: @"2" } eachEntry:^(id entry) {
                count++;
                [[entry[0] should] beKindOfClass:[NSNumber class]];
                [[entry[1] should] beKindOfClass:[NSString class]];
            }];
            [[theValue(count) should] equal:theValue(2)];
        });

    });

    context(@"function style", ^{

        it(@"enumerates over key-value pairs", ^{
            __block NSUInteger count = 0;
            @{ @1: @"1", @2: @"2" }.eachEntry(^(id entry) {
                count++;
                [[entry[0] should] beKindOfClass:[NSNumber class]];
                [[entry[1] should] beKindOfClass:[NSString class]];
            });
            [[theValue(count) should] equal:theValue(2)];
        });

    });

});

SPEC_END
