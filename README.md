# EnumeratorKit — Ruby-style enumeration in Objective-C

[![Build Status](https://travis-ci.org/sharplet/EnumeratorKit.svg?branch=master)](https://travis-ci.org/sharplet/EnumeratorKit)

EnumeratorKit is a collection enumeration library modelled after Ruby's
`Enumerable` module and `Enumerator` class.

It allows you to work with collections of objects in a very compact,
expressive way:

```objc
#import <EnumeratorKit.h>

NSArray *numbers = @[ @1, @2, @3 ];

// perform the block once for each element in the collection
[numbers each:^(id i){
    NSLog(@"%@", i);
}];

// return a new array with each element converted to a string
[numbers map:^(id i){
    return [i stringValue];
}];
```

Additionally, these operations can be chained together to form a
higher-level operation:

```objc
NSDictionary *examples = @{ @"Hello": @"world", @"foo": @"BAR" };

[[[examples sortBy:^(id p){
    // sort entries by their keys, case insensitive
    return [p[0] lowercaseString];
}] map:^(id p){
    // combine each key-value pair into a new string
    return [NSString stringWithFormat:@"%@ %@", p[0], p[1]];
}] select:^(id p){
    return [p[1] hasSuffix:@"orld"];
}];
// => @[@"Hello world"];
```

EnumeratorKit implements this functionality for all of the core
collection classes (and their mutable counterparts): `NSArray`,
`NSDictionary`, `NSSet` and `NSOrderedSet`.

EnumeratorKit also provides the `EKEnumerator` class, which has a
number of advantages over `NSEnumerator`, for example:

 - The ability to `peek` at the next element without consuming the
   enumeration
 - Implements the entire `EKEnumerable` API
 - Lazy enumeration over an infinite collection:

```objc
// you may have seen this in Ruby before
EKEnumerator *fib = [EKEnumerator new:^(id<EKYielder> y){
    int a = 1, b = 1;
    while (1) { // infinite loop (!)
        [y yield:@(a)];
        NSUInteger next = a + b;
        a = b; b = next;
    }
}];
[fib take:10]; // => @[ @1, @1, @2, @3, @5, @8, @13, @21, @34, @55 ]
```


## Getting Started

### Installation

EnumeratorKit is available via [CocoaPods]. Add it to your `Podfile`:

```ruby
pod 'EnumeratorKit', '~> 0.1.1'
```

(And don't forget to `pod install`.) Then import the header:

```objc
#import <EnumeratorKit.h>
```

Now you're ready to go.

(Note: If you're interested in using `EKFiber` without the rest of
`EKEnumerable`, you can use this subspec: `pod
'EnumeratorKit/EKFiber'`.)

[CocoaPods]: https://github.com/CocoaPods/CocoaPods "CocoaPods on GitHub"


### Requirements

 - iOS 5.0+
 - Base SDK with support for Objective-C collection literals


## How it works

The `EKEnumerable` class defines an API of methods that are all based on one operation:

```objc
- (id<EKEnumerable)each:(void (^)(id obj))block;
```

Different collection classes implement their own version of `-each:`,
to define the order their elements should be traversed. For example, on
`NSArray`, `-each:` is defined to execute the block once for each item
in turn. For `NSDictionary`, `-each:` constructs an array `@[key,
value]` and passes it to the block once for each entry.

EnumeratorKit then uses the Objective-C runtime to "mix in" to another
class all the methods defined in `EKEnumerable` (*a la* Ruby modules).
This is similar to using an Objective-C category to add methods to an
existing class, but is done entirely at runtime. (There is also the
added benefit that if you subclass an `EKEnumerable` class, you can
override any of the methods provided by `EKEnumerable`. Category
methods, however, would break polymorphism.)

By defining the API in terms of `-each:`, any class can gain the
functionality just by implementing that method and mixing in
`EKEnumerable`.


## Available methods

Complete API documentation is coming! In the meantime, [the Kiwi
tests][tests] provide a lot of useful examples. (If you're interested in
reading more, I'd also recommend having a look at Ruby's [Enumerable
docs][rb-enumerable].) Here's a whirlwhind tour of the supported
operations:

 - `-each` — perform the block once for each item in the collection
 - `-eachWithIndex` — like `-each`, but with the current index passed
   as a second argument to the block
 - `-asArray` — get an array representation of any enumeration
 - `-take` — get the specified number of elements from the beginning
   of the enumeration
 - `-map` — create a new array with the results of applying the block
   to each item in the collection
 - `-filter` — create a new array with all the elements for which the
   block returns `YES`
 - `-find` — return the first element for which the block returns
   `YES`, or `nil`
 - `-any` — check if an element in the collection passes the block
 - `-all` — check if all elements in the collection pass the block
 - `-sort` — return a sorted array (items in the collection must
   respond to `compare:`)
 - `-sortWith` — like `-sort`, but allows you to specify an
   `NSComparator`
 - `-sortBy` — use the result of applying the block to each element
   as sort keys for sorting the receiver
 - `-inject`/`-reduce` — compute the result of "injecting" the binary
   operation or block between each item in the collection, e.g., to sum
   a list of numbers, or to build a new collection in an accumulator
   variable

[tests]: https://github.com/sharplet/EnumeratorKit/tree/master/Tests
[rb-enumerable]: http://ruby-doc.org/core-2.0/Enumerable.html "Enumerable | ruby-doc.org"


## Making your own collection classes enumerable

You can very easily get the benefit of the entire `EKEnumerable` API in
your own collection classes:

#### 1. Adopt the `EKEnumerable` protocol in your class's public interface

```objc
# import <EnumeratorKit.h>
@interface MyAwesomeCollection : NSObject <EKEnumerable>
...
@end
```

#### 2. In the implementation, override `+load` and `includeEKEnumerable`

```obc
+ (void)load
{
    [self includeEKEnumerable];
}
```

#### 3. Implement `-each:`

```objc
@implementation MyAwesomeCollection
.
.
.
- (id<EKEnumerable>)each:(void (^)(id))block
{
    // hypothetical enumeration code
    for (int i; i < self.length; i++) {
        // call the block, passing in each element
        block(self[i]);
    }

    // make sure you return self, to enable enumerator chaining
    return self;
}
.
.
.
@end
```


## To do

The following features are planned:

 - Documentation!
 - OS X support
 - Lazy enumerator chains
 - Expansion of `EKEnumerable` with more features (requests welcome)
 - Update `EKFiber` to support the `-transfer` operation


## Contributing

Wow! Pull requests are most welcome (especially for bugs). However in
most cases it would be best to first open a new issue and start a
discussion.


## Acknowledgements

Implementing the first version of this project taught me a whole lot
about Objective-C, and Ruby's `Enumerable` and `Enumerator`
functionality. Special thanks to:

 - ["Building Enumerable & Enumerator in Ruby" at Practicing
   Ruby][practicing-ruby]. This article heavily influenced the
   implementation of `EKEnumerable` and `EKEnumerator`.
 - [@alskipp][] for [his implementation of Fibers in
   MacRuby][macruby-fibers] — this really helped me tease out the
   race conditions in `EKFiber`!
 - [ReactiveCocoa][] for bringing some functional goodness to
   Objective-C programming.
 - [CocoaPods][] and [Kiwi][].
 - [@alaroldai][] for digging the idea.

[practicing-ruby]: https://practicingruby.com/articles/shared/eislpkhxolnr "Building Enumerable & Enumerator in Ruby | Practicing Ruby"
[@alskipp]: https://github.com/alskipp "alskipp on GitHub"
[macruby-fibers]: https://github.com/alskipp/MacrubyFibers/blob/master/lib/fiber.rb "alskipp/MacrubyFibers on GitHub"
[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa
[CocoaPods]: https://github.com/CocoaPods/CocoaPods "CocoaPods on GitHub"
[Kiwi]: https://github.com/allending/Kiwi "Kiwi on GitHub"
[@alaroldai]: https://github.com/alaroldai "alaroldai on GitHub"
