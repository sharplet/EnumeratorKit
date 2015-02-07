#import <Kiwi/Kiwi.h>
#import <EnumeratorKit/EnumeratorKit.h>
#import "SortedList.h"

@interface EnumerableSubclass : SortedList
@end

@implementation EnumerableSubclass
- (instancetype)map:(id (^)(id))block
{
    return [[[self class] alloc] initWithEnumerable:@[ @"specific implementation" ]];
}
@end

SPEC_BEGIN(NSObjectIncludeEKEnumerableSpec)

describe(@"NSObject+IncludeEKEnumerable", ^{

    describe(@"-includeEnumerable", ^{

        context(@"in a class that includes EKEnumerable directly", ^{

            it(@"uses the default implementation of map:", ^{
                id list = [[[SortedList new] insert:@2] insert:@1];
                id result = [list map:^id(id obj) {
                    return [NSString stringWithFormat:@"%@", obj];
                }];
                [[result should] equal:[[SortedList alloc] initWithArray:@[ @"1", @"2" ]]];
            });

        });

        context(@"in a subclass of an enumerable class, that provides its own map: implementation", ^{

            it(@"uses the subclass's implementation of map:", ^{
                id list = [[[EnumerableSubclass new] insert:@2] insert:@1];
                id result = [list map:^id(id obj) {
                    return [NSString stringWithFormat:@"%@", obj];
                }];
                [[result should] equal:[[EnumerableSubclass alloc] initWithArray:@[ @"specific implementation" ]]];
            });

        });

    });

});

SPEC_END
