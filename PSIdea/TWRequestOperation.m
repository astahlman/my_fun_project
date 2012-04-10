//
//  TWRequestOperation.m
//  PSIdea
//
//  Created by Andrew Stahlman on 4/5/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "TWRequestOperation.h"
#import "Logging.h"

@implementation TWRequestOperation

@synthesize request = _request;

-(id)initWithRequest:(TWRequest *)request
{
    self = [super init];
    if (self != nil)
    {
        _request = request;
        _jsonParser = [[SBJsonParser alloc] init];
    }
    return self;
}

#pragma operation methods

-(void)cancel
{
    // don't respond to cancel if we have already begun
    if (_operationState == OperationStateNotStarted)
    {
        [self willChangeValueForKey:@"isFinished"];
        _operationState = OperationStateCancelled;
        [self didChangeValueForKey:@"isFinished"];
    }
    
}

-(BOOL)isExecuting
{
    return _operationState == OperationStateExecuting;
}

-(BOOL)isFinished
{
    return (_operationState == OperationStateSuccess || _operationState == OperationStateFailed || _operationState == OperationStateCancelled);
}

-(BOOL)isConcurrent
{
    return NO;
}


-(void)main
{
    if (_operationState != OperationStateCancelled)
    {
        [self willChangeValueForKey:@"isExecuting"];
        _operationState = OperationStateExecuting;
        [self didChangeValueForKey:@"isExecuting"];
        

        [_request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
         {
             NSDictionary* tweetResponse = [_jsonParser objectWithData:responseData];
             [[Logging logger] logMessage:[NSString stringWithFormat:@"Here is the tweet responseData: %@", tweetResponse]];
             NSIndexSet* acceptableCodes = [NSOperationWithState defaultAcceptableStatusCodes];
             if (![acceptableCodes containsIndex:[urlResponse statusCode]])
             {
                 [[Logging logger] logMessage:[NSString stringWithFormat:@"Failed to post tweet: response code %i", [urlResponse statusCode]]];
             }
             
         }];
        // else it must have failed or been cancelled, leave it as is
        if (_operationState == OperationStateExecuting)
        {
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            _operationState = OperationStateSuccess;
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
        }
    }
}

@end
