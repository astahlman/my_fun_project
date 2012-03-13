//
//  HTTPSynchOperation.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/12/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPSynchOperation.h"
#import "Logging.h"

@implementation HTTPSynchOperation

@synthesize responseBody = _responseBody;
@synthesize request = _request;
@synthesize response = _response;
@synthesize acceptableStatusCodes = _acceptableStatusCodes;
@synthesize acceptableContentTypes = _acceptableContentTypes;
//@synthesize delegate;

+(NSIndexSet*)defaultAcceptableStatusCodes
{
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 99)];
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

-(id)initWithRequest:(NSURLRequest*)request
{
    self = [super init];
    _request = request;
    return self;
}

-(id)copyWithZone:(NSZone*)zone
{
    HTTPSynchOperation* clone = [[self class] allocWithZone:zone];
    [clone setResponseBody:_responseBody];
    [clone setRequest:_request];
    [clone setResponse:_response];
    [clone setAcceptableStatusCodes:_acceptableStatusCodes];
    [clone setAcceptableContentTypes:_acceptableContentTypes];
    //[clone setDelegate:[self delegate]];
    return clone;
}

-(void)main
{
    if (_operationState != OperationStateCancelled)
    {
        [self willChangeValueForKey:@"isExecuting"];
        _operationState = OperationStateExecuting;
        [self didChangeValueForKey:@"isExecuting"];
        
        _responseBody = [self executeRequest:_request];
        [[Logging logger] logMessage:[[NSString alloc] initWithData:_responseBody encoding:NSUTF8StringEncoding]];
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

-(NSData*)executeRequest:(NSURLRequest*)request
{
    NSError* err;
    NSHTTPURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    _response = response;
    if (err != nil)
    {
        [[Logging logger] logMessage:err.description];
        [self failWithError:OperationErrorConnectionError];
    }
    return data;
}

@end
