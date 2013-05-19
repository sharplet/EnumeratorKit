//
//  FakeEnumerator.m
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "FakeEnumerator.h"
#import "Fiber.h"

@interface FakeEnumerator ()

@property (nonatomic, copy) void (^block)(id);
@property (nonatomic) Fiber *fiber;

@end

@implementation FakeEnumerator

+ (instancetype)enumeratorWithBlock:(void (^)(id<Yielder> y))block
{
    return [[self alloc] initWithBlock:block];
}
- (id)initWithBlock:(void (^)(id<Yielder> y))block
{
    if (self = [super init]) {
        _block = [block copy];
    }
    return self;
}

- (id)each
{
    return self;
}
- (id)each:(void (^)(id))block
{
    id obj;
    while ((obj = self.next)) {
        block(obj);
    }
    return self.rewind;
}

- (id)next
{
    if (!self.fiber) {
        __weak FakeEnumerator *weakSelf = self;
        self.fiber = [Fiber fiberWithBlock:^id{
            weakSelf.block([Fiber class]);
            return nil;
        }];
    }

    return self.fiber.resume;
}

- (id)rewind
{
    self.fiber = nil;
    return self;
}

- (id)withIndex:(id (^)(id, id))block
{
    return nil;
}

@end
