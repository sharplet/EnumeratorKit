#import <Kiwi.h>
#import "EKEnumerator.h"
#import "SortedList.h"
#import "NSNumber+BinaryOperations.h"

SPEC_BEGIN(EKEnumeratorDemo)

describe(@"EKEnumerator", ^{

    __block SortedList * list;
    beforeAll(^{
        list = [[SortedList alloc] init];

        // will get stored internally as 3,4,7,13,42
        [[[[[list insert:@3] insert:@13] insert:@42] insert:@4] insert:@7];
    });

    it(@"supports next", ^{
        EKEnumerator * e = list.each;

        [[e.next should] equal:@3];
        [[e.next should] equal:@4];
        [[e.next should] equal:@7];
        [[e.next should] equal:@13];
        [[e.next should] equal:@42];

        [e.next shouldBeNil];
    });

    it(@"supports rewind", ^{
        EKEnumerator * e = list.each;

        (void)e.next;
        (void)e.next;
        (void)e.next;
        (void)e.next;
        (void)e.rewind;

        (void)e.next;
        (void)e.next;

        [[e.next should] equal:@7];
    });

    it(@"supports peek", ^{
        EKEnumerator * e = list.each;

        [[e.peek should] equal:@3];
        [[e.next should] equal:@3];
        [[e.peek should] equal:@4];
        [[e.peek should] equal:@4];
        [[e.next should] equal:@4];
        [[e.next should] equal:@7];

        [[e.next should] equal:@13];
        [[e.next should] equal:@42];

        [e.peek shouldBeNil];
    });

//    it(@"supports withIndex", ^{
//        EKEnumerator * e = list.map;
//        id expected = @[ @"0. 3", @"1. 4", @"2. 7", @"3. 13", @"4. 42" ];
//
//        [[[e withIndex:^id(id obj, id index) {
//            return [NSString stringWithFormat:@"%@. %@", obj, index];
//        }] should] equal:expected];
//    });

    describe(@"infinite enumeration", ^{

        it(@"iterates over the fibonacci sequence", ^{
            // describe the fibonacci sequence with an enumerator
            EKEnumerator * fib = [EKEnumerator enumeratorWithBlock:^(id<EKYielder> y) {
                id a = @1, b = @1;
                while (1) {
                    [y yield:a];
                    id next = [a add:b];
                    a = b; b = next;
                }
            }];

            // get the first 10 elements
            NSMutableArray *result = [NSMutableArray new];
            for (int i = 0; i < 10; i++) {
                [result addObject:fib.next];
            }

            [[result should] equal:@[ @1, @1, @2, @3, @5, @8, @13, @21, @34, @55 ]];
        });

    });

});

SPEC_END
