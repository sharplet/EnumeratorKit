#import <Kiwi.h>
#import "NSDictionary+EKEnumerable.h"

SPEC_BEGIN(EKEnumerableNSDictionarySpec)

describe(@"-initWithEnumerable:", ^{

    it(@"constructs a dictionary from alternating keys and values", ^{
        NSArray *keysAndValues = @[@"foo", @3, @"foobar", @6];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithEnumerable:keysAndValues];
        [[dictionary should] equal:@{@"foo": @3, @"foobar": @6}];
    });

    it(@"ignores a trailing key with no value", ^{
        NSArray *keysAndValues = @[@"foo", @3, @"foobar"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithEnumerable:keysAndValues];
        [[dictionary should] equal:@{@"foo": @3}];
    });

});

describe(@"-each", ^{

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

describe(@"-eachPair", ^{

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

describe(@"-eachEntry", ^{

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

describe(@"-eachKey", ^{

    it(@"enumerates over keys", ^{
        __block NSUInteger count = 0;
        [@{ @1: @"1", @2: @"2" } eachKey:^(id key) {
            count++;
            [[key should] beKindOfClass:[NSNumber class]];
        }];
        [[theValue(count) should] equal:theValue(2)];
    });

});

describe(@"-eachObject", ^{

    it(@"enumerates over objects", ^{
        __block NSUInteger count = 0;
        [@{ @1: @"1", @2: @"2" } eachObject:^(id obj) {
            count++;
            [[obj should] beKindOfClass:[NSString class]];
        }];
        [[theValue(count) should] equal:theValue(2)];
    });

});

describe(@"-map:", ^{

    it(@"returns a new dictionary with the receivers values transformed by the block", ^{
        NSDictionary *dictionary = @{@"a": @1, @"b": @2};
        NSDictionary *doubled = [dictionary map:^(id pair) {
            return @([pair[1] integerValue] * 2);
        }];
        [[doubled should] equal:@{@"a": @2, @"b": @4}];
    });

});

describe(@"-flattenMap:", ^{

    it(@"merges the contents of each resulting dictionary, giving the set of values for each key", ^{
        NSDictionary *people = @{
            @"person1": @{@"name": @"Steve von Sharp", @"age": @30},
            @"person2": @{@"name": @"Jess Smith", @"age": @25},
            @"person3": @{@"name": @"Tristan", @"age": @25},
        };

        NSDictionary *stats = [people flattenMap:^(id pair) {
            NSDictionary *person = pair[1];
            return @{
                 @"number of names": @([person[@"name"] componentsSeparatedByString:@" "].count),
                 @"age": person[@"age"],
            };
        }];

        [[stats[@"number of names"] should] equal:[NSSet setWithArray:@[@1, @2, @3]]];
        [[stats[@"age"] should] equal:[NSSet setWithArray:@[@25, @30]]];
    });

});

describe(@"-select:", ^{

    it(@"returns a new dictionary with only matching entries", ^{
        NSDictionary *dictionary = @{@"a": @1, @"b": @2};
        NSDictionary *even = [dictionary select:^BOOL(id pair) {
            return [pair[1] integerValue] % 2 == 0;
        }];
        [[even should] equal:@{@"b": @2}];
    });

});

SPEC_END
