#import <Kiwi/Kiwi.h>
#import <EnumeratorKit/EnumeratorKit.h>

SPEC_BEGIN(EKEnumerableNSOrderedSetSpec)

describe(@"-initWithEnumerable:", ^{

    it(@"constructs an ordered set respecting the order of the enumerable", ^{
        NSArray *array = @[@2, @1, @3];
        NSOrderedSet *orderedSet = [[NSOrderedSet alloc] initWithEnumerable:array];
        [[orderedSet should] equal:[NSOrderedSet orderedSetWithArray:@[@2, @1, @3]]];
    });

});

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
