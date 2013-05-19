#import <Kiwi.h>
#import "SortedList.h"

SPEC_BEGIN(FakeEnumerableSpec)

describe(@"FakeEnumerable", ^{

    __block id list;
    beforeAll(^{
        list = [[SortedList alloc] init];

        // will get stored internally as 3,4,7,13,42
        [[[[[list insert:@3] insert:@13] insert:@42] insert:@4] insert:@7];
    });

    it(@"supports map", ^{
        [[[list map:^id(id obj) {
            return @([obj integerValue] + 1);
        }] should] equal:@[ @4, @5, @8, @14, @43 ]];
    });

//    it(@"supports sortBy", ^{
//        // ascii sort order
//        [[[list sortBy:^id(id obj) {
//            return [NSString stringWithFormat:@"%@", obj];
//        }] should] equal:@[ @13, @3, @4, @42, @7 ]];
//    });

    it(@"supports filter", ^{
        [[[list filter:^BOOL(id obj) {
            return [obj integerValue] % 2 == 0;
        }] should] equal:@[ @4, @42 ]];
    });

    it(@"supports inject/reduce", ^{
        [[[list inject:@selector(add:)] should] equal:@69];
        [[[list reduce:^id(id memo, id obj) {
            return [memo add:obj];
        }] should] equal:@69];
    });

});

SPEC_END
