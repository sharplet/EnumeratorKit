#import <Kiwi.h>
#import "NSArray+EKEnumerable.h"

@interface NSNumber (BinaryOperations)
- (instancetype)add:(NSNumber *)number;
@end

@implementation NSNumber (BinaryOperations)

- (instancetype)add:(NSNumber *)number
{
    return @([self doubleValue] + [number doubleValue]);
}

@end

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

describe(@"-eachWithIndex", ^{

    context(@"message style", ^{

        it(@"yields each object and its index to the block", ^{
            NSMutableArray *objects = [NSMutableArray array], *indexes = [NSMutableArray array];
            [@[@"foo", @"bar", @"baz"] eachWithIndex:^(id obj, NSUInteger i) {
                [objects addObject:obj];
                [indexes addObject:@(i)];
            }];

            [[objects should] equal:@[@"foo",@"bar",@"baz"]];
            [[indexes should] equal:@[@0,@1,@2]];
        });

    });

    context(@"function style", ^{

        it(@"yields each object and its index to the block", ^{
            NSMutableArray *objects = [NSMutableArray array], *indexes = [NSMutableArray array];
            @[@"foo", @"bar", @"baz"].eachWithIndex(^(id obj, NSUInteger i) {
                [objects addObject:obj];
                [indexes addObject:@(i)];
            });

            [[objects should] equal:@[@"foo",@"bar",@"baz"]];
            [[indexes should] equal:@[@0,@1,@2]];
        });

    });

});

describe(@"-take", ^{

    context(@"message style", ^{

        it(@"returns an empty array if you take 0", ^{
            id result = [@[@1,@2,@3] take:0];
            [[result should] equal:@[]];
        });

        it(@"returns the specified number of elements if you take < the collection's length", ^{
            id result = [@[@1,@2,@3] take:2];
            [[result should] equal:@[@1,@2]];
        });

        it(@"returns all elements if you take >= the collection's length", ^{
            id result = [@[@1,@2,@3] take:5];
            [[result should] equal:@[@1,@2,@3]];
        });

        it(@"always begins at the start, if called on an enumerator", ^{
            EKEnumerator *e = [EKEnumerator enumeratorWithBlock:^(id<EKYielder> y) {
                [@[@1,@2,@3] each:^(id obj) {
                    [y yield:obj];
                }];
            }];

            (void)e.next;
            id result = [e take:2];
            [[result should] equal:@[@1,@2]];
        });

        it(@"returns the whole collection if passed a negative number", ^{
            id result = [@[@1,@2,@3] take:-1];
            [[result should] equal:@[@1,@2,@3]];
        });

    });

    context(@"function style", ^{

        it(@"returns an empty array if you take 0", ^{
            id result = @[@1,@2,@3].take(0);
            [[result should] equal:@[]];
        });

        it(@"returns the specified number of elements if you take < the collection's length", ^{
            id result = @[@1,@2,@3].take(2);
            [[result should] equal:@[@1,@2]];
        });

        it(@"returns all elements if you take >= the collection's length", ^{
            id result = @[@1,@2,@3].take(5);
            [[result should] equal:@[@1,@2,@3]];
        });

    });

});

describe(@"-asArray", ^{

    it(@"enumerates the entire collection and returns an array", ^{
        id result = @{ @1: @"1", @2: @"2" }.asArray;
        [[result should] equal:@[@[@1,@"1"], @[@2,@"2"]]];
    });

    it(@"returns self if the receiver is an array", ^{
        NSArray *orig = @[@1,@2];
        NSArray *result = orig.asArray;
        [[result should] beIdenticalTo:orig];
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

    it(@"preserves the cardinality of the enumerable by inserting NSNull for nil", ^{
        id nulls = [@[@1,@2,@3] map:^id(id i) { return nil; }];
        [[nulls should] equal:@[ [NSNull null], [NSNull null], [NSNull null] ]];
    });

});

describe(@"-flattenMap", ^{

    context(@"message style", ^{

        it(@"returns a new array with the flattened result of applying the block to each item in the array", ^{
            [[[@[@1, @2, @3, @4] flattenMap:^(id e){
                return @[e, @(-[e integerValue])];
            }] should] equal:@[@1, @(-1), @2, @(-2), @3, @(-3), @4, @(-4)]];
        });

    });

    context(@"function style", ^{

        it(@"returns a new array with the flattened result of applying the block to each item in the array", ^{
            [[@[@1, @2, @3, @4].flattenMap(^(id e){
                return @[e, @(-[e integerValue])];
            }) should] equal:@[@1, @(-1), @2, @(-2), @3, @(-3), @4, @(-4)]];
        });

    });

});

describe(@"-mapDictionary", ^{

    context(@"message style", ^{

        it(@"uses the mapped entries to construct a dictionary", ^{
            [[[@[@1, @2, @3] mapDictionary:^NSDictionary *(id obj) {
                return @{obj: [obj stringValue]};
            }] should] equal:@{
                @1: @"1",
                @2: @"2",
                @3: @"3"
            }];
        });

        it(@"raises an exception if the dictionary has more than one entry", ^{
            [[theBlock(^{
                [@[@"foo"] mapDictionary:^(id i){ return @{@1: @"1", @2: @"2", @3: @"3"}; }];
            }) should] raise];
        });

        it(@"skips entries that are nil or empty", ^{
            [[[@[@"foobar", @1234, [NSObject new]] mapDictionary:^NSDictionary *(id obj){
                if ([obj isKindOfClass:[NSNumber class]]) {
                    return @{obj: [obj stringValue]};
                }
                else if ([obj isKindOfClass:[NSString class]]) {
                    return @{};
                }
                else {
                    return nil;
                }
            }] should] equal:@{ @1234: @"1234" }];
        });

    });

    context(@"function style", ^{

        it(@"uses the mapped entries to construct a dictionary", ^{
            [[@[@1, @2, @3].mapDictionary(^NSDictionary *(id obj) {
                return @{obj: [obj stringValue]};
            }) should] equal:@{
                @1: @"1",
                @2: @"2",
                @3: @"3"
            }];
        });

    });

    context(@"with a block that returns duplicate keys", ^{
        NSDictionary *(^mapDictionaryBlock)(id) = ^NSDictionary *(id obj){
            return @{@"duplicate": obj};
        };

        __block NSArray *numbers;
        beforeEach(^{ numbers = @[@1, @2]; });

        it(@"uses the last value added for the key", ^{
            NSDictionary *result = [numbers mapDictionary:mapDictionaryBlock];
            [[result[@"duplicate"] should] equal:@2];
        });
    });

});

describe(@"-wrap:", ^{
    __block NSDictionary *user1, *user2;
    __block NSArray *users;

    id<NSCopying> (^userToName)(id) = ^(id u){ return u[@"name"]; };
    id<NSCopying> (^alwaysTheSameKey)(id) = ^(id obj){ return @"duplicate"; };

    beforeEach(^{
        user1 = @{@"name": @"sharplet", @"URL": @"https://github.com/sharplet"};
        user2 = @{@"name": @"foo",      @"URL": @"http://bar.example.com/"};
    });

    context(@"with a single element", ^{
        beforeEach(^{ users = @[user1]; });

        it(@"wraps the element in the returned key", ^{
            NSDictionary *usersByName = [users wrap:userToName];
            [[usersByName[@"sharplet"] should] equal:user1];
        });
    });

    context(@"with multiple elements", ^{
        beforeEach(^{ users = @[user1, user2]; });

        it(@"wraps all elements in their returned keys", ^{
            NSDictionary *usersByName = [users wrap:userToName];
            [[usersByName should] equal:@{@"sharplet": user1, @"foo": user2}];
        });

        it(@"returns the last value for a duplicate key", ^{
            NSDictionary *usersByName = [users wrap:alwaysTheSameKey];
            [[usersByName should] equal:@{@"duplicate": user2}];
        });
    });

});

describe(@"-select", ^{

    context(@"message style", ^{

        it(@"selects the matching items from the enumerable", ^{
            id result = [@[@1,@2,@3] select:^BOOL(id obj) {
                return [obj integerValue] % 2 == 0;
            }];
            [[result should] equal:@[@2]];
        });

    });

    context(@"function style", ^{

        it(@"selects the matching items from the enumerable", ^{
            id result = @[@1,@2,@3].select(^BOOL(id obj) {
                return [obj integerValue] % 2 == 0;
            });
            [[result should] equal:@[@2]];
        });

    });

});

describe(@"-filter", ^{

    context(@"message style", ^{

        it(@"selects matching items from the enumerable", ^{
            id result = [@[@1,@2,@3] filter:^BOOL(id obj) {
                return [obj integerValue] % 2 == 0;
            }];
            [[result should] equal:@[@2]];
        });

    });

    context(@"function style", ^{

        it(@"selects matching items from the enumerable", ^{
            id result = @[@1,@2,@3].filter(^BOOL(id obj) {
                return [obj integerValue] % 2 == 0;
            });
            [[result should] equal:@[@2]];
        });

    });

});

describe(@"-reject", ^{

    context(@"message style", ^{

        it(@"removes matching items from the enumerable", ^{
            id result = [@[@1,@2,@3] reject:^BOOL(id obj) {
                return [obj integerValue] % 2 == 0;
            }];
            [[result should] equal:@[@1,@3]];
        });

    });

    context(@"function style", ^{

        it(@"removes matching items from the enumerable", ^{
            id result = @[@1,@2,@3].reject(^BOOL(id obj) {
                return [obj integerValue] % 2 == 0;
            });
            [[result should] equal:@[@1,@3]];
        });

    });

});

describe(@"-groupBy", ^{

    context(@"message style", ^{

        it(@"groups items by the return value of the block", ^{
            NSArray *numbers = @[@3, @1, @4, @1, @5, @9, @2, @6, @5, @3, @5];
            NSDictionary *expectedResult = @{
                @NO: @[@3, @1, @1, @5, @9, @5, @3, @5],
                @YES: @[@4, @2, @6]
            };

            [[[numbers groupBy:^id<NSCopying>(id obj) {
                return @([obj integerValue] % 2 == 0); // @YES if even, otherwise @NO
            }] should] equal:expectedResult];
        });

        it(@"uses [NSNull null] as the key when the block returns nil", ^{
            [[[@[@1, @2, @3] groupBy:^id<NSCopying>(id obj) {
                return [obj isEqual:@1] ? @"1" : nil;
            }] should] equal:@{
                @"1": @[@1],
                [NSNull null]: @[@2, @3]
            }];
        });

    });

});

describe(@"-chunk", ^{

    NSArray *strings = @[@"foo", @"bar", @"baz"];

    id (^firstChar)(id) = ^id(id string) {
        return [string substringToIndex:1];
    };

    it(@"returns the correct number of chunks", ^{
        [[[strings chunk:firstChar] should] haveCountOf:2];
    });

    it(@"groups items by the return value of the block", ^{
        NSArray *actualResult = [strings chunk:firstChar];
        [[actualResult should] equal:@[
            @[@"f", @[@"foo"]],
            @[@"b", @[@"bar", @"baz"]]
        ]];
    });

    it(@"doesn't join non-continous groups", ^{
        NSArray *strings = @[@"baz", @"foo", @"bar"];
        NSArray *actualResult = [strings chunk:firstChar];
        [[actualResult should] equal:@[
            @[@"b", @[@"baz"]],
            @[@"f", @[@"foo"]],
            @[@"b", @[@"bar"]]
        ]];
        [[actualResult shouldNot] equal:@[
            @[@"b", @[@"baz", @"bar"]],
            @[@"f", @[@"foo"]]
        ]];
    });

    context(@"function style", ^{

        it(@"groups items by the return value of the block", ^{
            NSArray *numbers = @[@3, @1, @4, @1, @5, @9, @2, @6, @5, @3, @5];
            NSDictionary *expectedResult = @{
                @NO: @[@3, @1, @1, @5, @9, @5, @3, @5],
                @YES: @[@4, @2, @6]
            };

            [[numbers.chunk(^id<NSCopying>(id obj) {
                return @([obj integerValue] % 2 == 0); // @YES if even, otherwise @NO
            }) should] equal:expectedResult];
        });

        it(@"uses [NSNull null] as the key when the block returns nil", ^{
            [[@[@1, @2, @3].chunk(^id<NSCopying>(id obj) {
                return [obj isEqual:@1] ? @"1" : nil;
            }) should] equal:@{
                @"1": @[@1],
                [NSNull null]: @[@2, @3]
            }];
        });

    });

});

describe(@"-sort", ^{

    it(@"sorts elements that respond to -compare:", ^{
        [[@[@2,@3,@1].sort should] equal:@[@1,@2,@3]];
        [[@[@"foo",@"bar",@"baz"].sort should] equal:@[@"bar",@"baz",@"foo"]];
    });

    it(@"sorts an array of arrays by comparing the first elemements if they exist", ^{
        [[@[ @[], @[@2], @[@1] ].sort should] equal:@[ @[@1], @[@2], @[] ]];
    });

    it(@"it sorts a dictionary by comparing keys", ^{
        [[@{ @"foo": @1, @"bar": @2 }.sort should] equal:@[ @[@"bar",@2], @[@"foo",@1] ]];
    });

});

describe(@"-sortBy", ^{

    context(@"message style", ^{

        it(@"uses the block's return value as the sort key", ^{
            [[[@[@"foo", @1] sortBy:^(id obj){
                return [NSString stringWithFormat:@"%@", obj];
            }] should] equal:@[@1, @"foo"]];
        });

    });

    context(@"function style", ^{

        it(@"uses the block's return value as the sort key", ^{
            [[@[@"foo", @1].sortBy(^(id obj){
                return [NSString stringWithFormat:@"%@", obj];
            }) should] equal:@[@1, @"foo"]];
        });

    });

});

describe(@"-find", ^{

    context(@"message style", ^{

        it(@"stops the first time the block returns YES and returns the object", ^{
            __block NSUInteger count = 0;
            [[[@[@1,@2,@3] find:^BOOL(id obj) {
                count++;
                return [obj integerValue] % 2 == 0;
            }] should] equal:@2];
            [[theValue(count) should] equal:theValue(2)];
        });

    });

    context(@"function style", ^{

        it(@"stops the first time the block returns YES and returns the object", ^{
            __block NSUInteger count = 0;
            [[@[@1,@2,@3].find(^BOOL(id obj) {
                count++;
                return [obj integerValue] % 2 == 0;
            }) should] equal:@2];
            [[theValue(count) should] equal:theValue(2)];
        });

    });

});

describe(@"-any", ^{

    context(@"message style", ^{

        it(@"stops the first time the block returns YES and returns YES", ^{
            __block NSUInteger count = 0;
            [[@([@[@1,@2,@3] any:^BOOL(id obj) {
                count++;
                return [obj integerValue] % 2 == 0;
            }]) should] equal:@YES];
            [[theValue(count) should] equal:theValue(2)];
        });

        it(@"returns NO if block always returns NO", ^{
            __block NSUInteger count = 0;
            [[@([@[@1,@2,@3] any:^BOOL(id obj) {
                count++;
                return [obj integerValue] > 3;
            }]) should] equal:@NO];
            [[theValue(count) should] equal:theValue(3)];
        });

    });

});

describe(@"-all", ^{

    context(@"message style", ^{

        it(@"stops the first time the block returns NO and returns NO", ^{
            __block NSUInteger count = 0;
            [[@([@[@1,@2,@3] all:^BOOL(id obj) {
                count++;
                return [obj integerValue] % 2 != 0;
            }]) should] equal:@NO];
            [[theValue(count) should] equal:theValue(2)];
        });

        it(@"returns YES if block always returns YES", ^{
            __block NSUInteger count = 0;
            [[@([@[@1,@2,@3] all:^BOOL(id obj) {
                count++;
                return [obj integerValue] <= 3;
            }]) should] equal:@YES];
            [[theValue(count) should] equal:theValue(3)];
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

        it(@"supports building an array", ^{
            id result = [@[@1,@2,@3] reduce:@[] withBlock:^id(id memo, id obj){
                [memo addObject:[NSString stringWithFormat:@"%@", obj]];
                return memo;
            }];
            [[result should] equal:@[@"1", @"2", @"3"]];
        });

        it(@"supports building a string", ^{
            id result = [@[@1,@2,@3] reduce:@"abc" withBlock:^id(id memo, id obj) {
                [memo appendString:[NSString stringWithFormat:@"%@", obj]];
                return memo;
            }];
            [[result should] equal:@"abc123"];
        });

        it(@"supports building a dictionary", ^{
            id result = [@[@1,@2,@3] reduce:@{} withBlock:^id(id memo, id obj) {
                [memo setObject:[NSString stringWithFormat:@"%@", obj] forKey:obj];
                return memo;
            }];
            [[result should] equal:@{ @1: @"1", @2: @"2", @3: @"3" }];
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

        it(@"supports building an array", ^{
            id result = @[@1,@2,@3].reduce(@[], ^id(id memo, id obj){
                [memo addObject:[NSString stringWithFormat:@"%@", obj]];
                return memo;
            });
            [[result should] equal:@[@"1", @"2", @"3"]];
        });

        it(@"supports building a string", ^{
            id result = @[@1,@2,@3].reduce(@"abc", ^id(id memo, id obj){
                [memo appendString:[NSString stringWithFormat:@"%@", obj]];
                return memo;
            });
            [[result should] equal:@"abc123"];
        });

        it(@"supports building a dictionary", ^{
            id result = @[@1,@2,@3].reduce(@{}, ^id(id memo, id obj){
                [memo setObject:[NSString stringWithFormat:@"%@", obj] forKey:obj];
                return memo;
            });
            [[result should] equal:@{ @1: @"1", @2: @"2", @3: @"3" }];
        });

    });

});

describe(@"-inject", ^{

    context(@"message style", ^{

        it(@"returns the result of applying the selector to each element and the total", ^{
            [[ (id)[@[@1,@2,@3] inject:@selector(add:)] should] equal:@6];
        });

        it(@"it starts from the initial value if provided", ^{
            [[ (id)[@[@2,@3] inject:@1 withOperation:@selector(add:)] should] equal:@6];
        });

        it(@"can append strings", ^{
            NSArray *letters = @[@"H", @"e", @"l", @"l", @"o"];
            NSString *word = [letters inject:@selector(stringByAppendingString:)];
            [[word should] equal:@"Hello"];
        });

    });

    context(@"function style", ^{

        it(@"behaves like -reduce single argument function style", ^{
            id total = @[@1,@2,@3].inject(^(id m, id i){
                return [m add:i];
            });
            [[total should] equal:@6];
        });

    });

});

SPEC_END
