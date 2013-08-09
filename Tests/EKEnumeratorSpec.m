#import <Kiwi.h>
#import "EKEnumerator.h"
#import "SortedList.h"

SPEC_BEGIN(EKEnumeratorSpec)

describe(@"-initWithObject", ^{

    it(@"returns an external -each: iterator for enumerable objects", ^{
        EKEnumerator *e = [EKEnumerator enumeratorWithObject:@[@1,@2,@3]];
        id result = [e take:3];
        [[result should] equal:@[@1,@2,@3]];
    });

    it(@"returns an iterator that yields the object, when passed a regular object", ^{
        EKEnumerator *e = [EKEnumerator enumeratorWithObject:@999];
        id result = [e take:3];
        [[result should] equal:@[@999]];
    });

});

describe(@"+new:", ^{

    it(@"creates a new enumerator using the block", ^{
        EKEnumerator *e = [EKEnumerator new:^(id<EKYielder> y) {
            [y yield:@"Hello, world"];
        }];
        [e shouldNotBeNil];
        [[e.next should] equal:@"Hello, world"];
    });

});

describe(@"-each", ^{

    it(@"doesn't consume an external iteration", ^{
        NSArray *array = @[@1,@2,@3];
        EKEnumerator *e = [EKEnumerator enumeratorWithBlock:^(id<EKYielder> y) {
            [array each:^(id obj) {
                [y yield:obj];
            }];
        }];

        (void)e.next;
        [e each:^(id obj){}];

        [[e.next should] equal:@2];
    });

});

describe(@"-rewind", ^{

    it(@"restarts the enumeration", ^{
        EKEnumerator *e = @[@1,@2,@3,@4,@5].asEnumerator;

        (void)e.next;
        (void)e.next;
        (void)e.next;
        (void)e.next;
        (void)e.rewind;

        (void)e.next;
        (void)e.next;

        [[e.next should] equal:@3];
    });

});

describe(@"infinite enumeration", ^{

    it(@"iterates over the fibonacci sequence", ^{
        // describe the fibonacci sequence with an enumerator
        EKEnumerator * fib = [EKEnumerator enumeratorWithBlock:^(id<EKYielder> y) {
            NSUInteger a = 1, b = 1;
            while (1) {
                [y yield:@(a)];
                NSUInteger next = a + b;
                a = b; b = next;
            }
        }];

        id result = [fib take:10];
        [[result should] equal:@[ @1, @1, @2, @3, @5, @8, @13, @21, @34, @55 ]];
    });

});

SPEC_END
