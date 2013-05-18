//
//  FakeEnumerator.m
//  FakeEnumerable
//
//  Created by Adam Sharp on 13/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#import "FakeEnumerator.h"
#import "SuppressPerformSelectorMemoryWarnings.h"
#import "Fiber.h"

@interface FakeEnumerator ()

@property (nonatomic, strong) id target;
@property (nonatomic) SEL selector;

@property (nonatomic) Fiber *fiber;

@end

@implementation FakeEnumerator

- (id)initWithTarget:(id)target selector:(SEL)selector
{
    if (self = [super init]) {
        _target = target;
        _selector = selector;
    }
    return self;
}

- (id)each
{
    return self;
}
- (id)each:(void (^)(id))block
{
    SuppressPerformSelectorLeakWarning(
        return [self.target performSelector:self.selector withObject:block];
    );
}

- (id)next
{
    if (!self.fiber) {
        self.fiber = [Fiber fiberWithBlock:^id{
            [self each:^(id obj) {
                [Fiber yield:obj];
            }];
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
