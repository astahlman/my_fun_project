//
//  NSOperationWithState.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/8/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NSOperationWithState.h"

@implementation NSOperationWithState

@synthesize operationState = _operationState;
@synthesize operationError = _operationError;

-(id)init
{
    self = [super init];
    _operationError = OperationErrorNone;
    _operationState = OperationStateNotStarted;
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
