//
//  NSOperationWithState.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/8/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NSOperationWithState.h"

#define MAX_ID 4294967295

@implementation NSOperationWithState

@synthesize operationState = _operationState;
@synthesize operationError = _operationError;
@synthesize operationID = _operationID;

-(id)init
{
    self = [super init];
    _operationError = OperationErrorNone;
    _operationState = OperationStateNotStarted;
    _operationID = [NSNumber numberWithLong:(arc4random() % MAX_ID)];
    return self;
}


-(void)failWithError:(OperationError)error
{
    _operationError = error;
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _operationState = OperationStateFailed;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
