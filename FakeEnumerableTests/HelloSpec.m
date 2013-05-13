#import <Kiwi.h>

SPEC_BEGIN(HelloSpec)

describe(@"it works", ^{

    it(@"hello", ^{
        id hello = @"hello";
        [[[hello stringByAppendingString:@" world"] should] equal:@"hello world"];
    });

    it(@"should instantiate a view controller", ^{
        UIViewController * vc = [[UIViewController alloc] init];
        [vc.view shouldNotBeNil];
    });

});

SPEC_END
