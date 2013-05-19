#import <Kiwi.h>
#import "FakeEnumerator.h"
#import "SortedList.h"

SPEC_BEGIN(FakeEnumeratorSpec)

describe(@"FakeEnumerable", ^{

    __block SortedList * list;
    beforeAll(^{
        list = [[SortedList alloc] init];

        // will get stored internally as 3,4,7,13,42
        [[[[[list insert:@3] insert:@13] insert:@42] insert:@4] insert:@7];
    });

    it(@"supports next", ^{
        FakeEnumerator * e = list.each;

        [[e.next should] equal:@3];
        [[e.next should] equal:@4];
        [[e.next should] equal:@7];
        [[e.next should] equal:@13];
        [[e.next should] equal:@42];

        [e.next shouldBeNil];
    });

    it(@"supports rewind", ^{
        FakeEnumerator * e = list.each;

        (void)e.next;
        (void)e.next;
        (void)e.next;
        (void)e.next;
        (void)e.rewind;

        (void)e.next;
        (void)e.next;

        [[e.next should] equal:@7];
    });

//    it(@"supports withIndex", ^{
//        FakeEnumerator * e = list.map;
//        id expected = @[ @"0. 3", @"1. 4", @"2. 7", @"3. 13", @"4. 42" ];
//
//        [[[e withIndex:^id(id obj, id index) {
//            return [NSString stringWithFormat:@"%@. %@", obj, index];
//        }] should] equal:expected];
//    });

});

SPEC_END
