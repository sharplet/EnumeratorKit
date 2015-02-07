#import <Kiwi/Kiwi.h>
#import "NSArray+EKEnumerable.h"

SPEC_BEGIN(EKEnumarbleNSArraySpec)

describe(@"-initWithEnumerable:", ^{

    it(@"it returns an array enumerating the objects in the enumerable", ^{
        NSOrderedSet *enumerable = [NSOrderedSet orderedSetWithArray:@[@1, @2, @3]];
        NSArray *array = [[NSArray alloc] initWithEnumerable:enumerable];
        [[array should] equal:@[@1, @2, @3]];
    });

});

SPEC_END
