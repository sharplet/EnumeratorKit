//
//  EKSerialOperationQueue.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 27/06/13.
//
//

@interface EKSerialOperationQueue : NSOperationQueue

- (void)addOperationWithBlockAndWait:(void (^)(void))block;

@end
