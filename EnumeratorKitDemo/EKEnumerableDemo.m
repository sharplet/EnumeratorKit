#import <Kiwi.h>
#import "EnumeratorKit.h"
#import "SortedList.h"
#import "NSNumber+BinaryOperations.h"

SPEC_BEGIN(EKEnumerableDemo)

describe(@"EKEnumerable", ^{

    __block id list;
    beforeAll(^{
        list = [[SortedList alloc] init];

        // will get stored internally as 3,4,7,13,42
        [[[[[list insert:@3] insert:@13] insert:@42] insert:@4] insert:@7];
    });

    it(@"supports map", ^{
        id mapped = [list map:^id(id obj) {
            return @([obj integerValue] + 1);
        }];
        [[mapped should] equal:@[ @4, @5, @8, @14, @43 ]];
    });

    it(@"supports filter", ^{
        id filtered = [list filter:^BOOL(id obj) {
            return [obj integerValue] % 2 == 0;
        }];
        [[filtered should] equal:@[ @4, @42 ]];
    });

    it(@"supports inject/reduce", ^{
        [[ (id)[list inject:@selector(add:)] should] equal:@69];

        id reduced = [list reduce:^id(id memo, id obj) {
            return [memo add:obj];
        }];
        [[reduced should] equal:@69];
    });

});

SPEC_END
