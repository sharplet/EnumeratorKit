#import <Kiwi.h>
#import "EKEnumerator.h"

SPEC_BEGIN(EKEnumeratorSpec)

describe(@"-initWithObject", ^{

    it(@"returns an external -each: iterator for enumerable objects", ^{
        EKEnumerator *e = [EKEnumerator enumeratorWithObject:@[@1,@2,@3]];
        id result = e.take(3);
        [[result should] equal:@[@1,@2,@3]];
    });

    it(@"returns an iterator that yields the object, when passed a regular object", ^{
        EKEnumerator *e = [EKEnumerator enumeratorWithObject:@999];
        id result = e.take(3);
        [[result should] equal:@[@999]];
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

SPEC_END
