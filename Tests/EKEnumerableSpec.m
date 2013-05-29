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
            [[indexes should] equal:@[@1,@2,@3]];
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
            [[indexes should] equal:@[@1,@2,@3]];
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
        id nulls = @[@1,@2,@3].map(^id(id i) { return nil; });
        [[nulls should] equal:@[ [NSNull null], [NSNull null], [NSNull null] ]];
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
