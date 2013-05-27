#import <Kiwi.h>
#import "NSObject+EKEnumerator.h"

SPEC_BEGIN(NSObjectAsEKEnumeratorSpec)

describe(@"-asEnumerator", ^{

    it(@"returns an enumerator initialised with the receiver", ^{
        NSObject *receiver = @999;
        [[EKEnumerator should] receive:@selector(enumeratorWithObject:) withArguments:receiver];
        (void)receiver.asEnumerator;
    });

});

SPEC_END
