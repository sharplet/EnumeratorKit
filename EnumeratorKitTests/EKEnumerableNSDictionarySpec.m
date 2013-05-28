#import <Kiwi.h>
#import "NSDictionary+EKEnumerable.h"

SPEC_BEGIN(EKEnumerableNSDictionarySpec)

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

describe(@"-eachKey", ^{

    context(@"message style", ^{

        it(@"enumerates over keys", ^{
            __block NSUInteger count = 0;
            [@{ @1: @"1", @2: @"2" } eachKey:^(id key) {
                count++;
                [[key should] beKindOfClass:[NSNumber class]];
            }];
            [[theValue(count) should] equal:theValue(2)];
        });

    });

    context(@"function style", ^{

        it(@"enumerates over keys", ^{
            __block NSUInteger count = 0;
            @{ @1: @"1", @2: @"2" }.eachKey(^(id key) {
                count++;
                [[key should] beKindOfClass:[NSNumber class]];
            });
            [[theValue(count) should] equal:theValue(2)];
        });

    });

});

describe(@"-eachObject", ^{

    context(@"message style", ^{

        it(@"enumerates over objects", ^{
            __block NSUInteger count = 0;
            [@{ @1: @"1", @2: @"2" } eachObject:^(id obj) {
                count++;
                [[obj should] beKindOfClass:[NSString class]];
            }];
            [[theValue(count) should] equal:theValue(2)];
        });

    });

    context(@"function style", ^{

        it(@"enumerates over objects", ^{
            __block NSUInteger count = 0;
            @{ @1: @"1", @2: @"2" }.eachObject(^(id obj) {
                count++;
                [[obj should] beKindOfClass:[NSString class]];
            });
            [[theValue(count) should] equal:theValue(2)];
        });

    });

});

SPEC_END
