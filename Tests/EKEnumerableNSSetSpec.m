#import <Kiwi/Kiwi.h>
#import <EnumeratorKit/EnumeratorKit.h>

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

describe(@"-map:", ^{

    it(@"returns the set of mapped values", ^{
        NSSet *set = [NSSet setWithArray:@[@"foo", @"bar", @"hello world"]];
        NSSet *lengths = [set map:^(NSString *s){ return @(s.length); }];
        [[lengths should] equal:[NSSet setWithArray:@[@3, @11]]];
    });

});

describe(@"-flattenMap:", ^{

    it(@"returns the union of the resulting sets", ^{
        NSSet *(^charactersInString)(NSString *) = ^(NSString *s) {
            NSMutableSet *characters = [NSMutableSet new];
            for (NSUInteger i = 0; i < s.length; i++) {
                [characters addObject:[s substringWithRange:NSMakeRange(i, 1)]];
            }
            return [characters copy];
        };

        NSSet *set = [NSSet setWithArray:@[@"foo", @"bar", @"hello world"]];
        NSSet *alphabet = [set flattenMap:charactersInString];
        [[alphabet should] equal:[NSSet setWithArray:@[@"f", @"o", @"b", @"a", @"r", @" ", @"h", @"e", @"l", @"w", @"d"]]];
    });

});

SPEC_END
