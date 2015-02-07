#import <Kiwi/Kiwi.h>
#import <EnumeratorKit/EnumeratorKit.h>

SPEC_BEGIN(EKEnumerateSpec)

describe(@"ek_enumerate", ^{

    it(@"allows mapping over an NSFastEnumeration", ^{
        NSArray *numbers = @[@1, @2, @3];
        NSArray *doubled = [[ek_enumerate(numbers) map:^(NSNumber *i) {
            return @(i.integerValue * 2);
        }] asArray];
        [[doubled should] equal:@[@2, @4, @6]];
    });

});

SPEC_END
