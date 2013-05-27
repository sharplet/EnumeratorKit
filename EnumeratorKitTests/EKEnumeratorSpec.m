#import <Kiwi.h>
#import "EKEnumerator.h"

SPEC_BEGIN(EKEnumeratorSpec)

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
