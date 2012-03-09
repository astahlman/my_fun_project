//
//  HTTPOperation.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/6/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPOperation.h"
#import "Logging.h"

@interface HTTPOperation()

-(BOOL)isContentTypeAcceptable;
-(BOOL)isResponseCodeAcceptable;

@end

@implementation HTTPOperation

-(id)initWithRequest:(NSURLRequest*)request 
{
    self = [super init];
    _request = request;
    _maxResponseSize = 1024 * 1024; // TODO: Calculate an appropriate value here
    return self;
}

+(NSIndexSet*)defaultAcceptableStatusCodes
{
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 99)];
}

#pragma operation methods

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
    return YES;
}

-(void)start
{
    if (_operationState != OperationStateCancelled)
    {
        _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
    
        [self willChangeValueForKey:@"isExecuting"];
        _operationState = OperationStateExecuting;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

-(void)cancel
{
    [_connection cancel];
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _operationState = OperationStateCancelled;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    [super cancel];
}

#pragma connection delegate methods

-(void)connection:(NSURLConnection*)conn didReceiveResponse:(NSURLResponse *)response
{
    _lastResponse = (NSHTTPURLResponse*) response;
}

-(void)connection:(NSURLConnection*)conn didReceiveData:(NSData *)data
{
    if (_dataAccumulator == nil)
    {
        assert(_lastResponse != nil);
        
        long long length = _lastResponse.expectedContentLength;
        
        if (length == NSURLResponseUnknownLength)
        {
            length = _maxResponseSize;
        }
        
        if (length <= _maxResponseSize)
        {
            _dataAccumulator = [[NSMutableData alloc] initWithLength:length];
        }
        else 
        {
            [self failWithError:OperationErrorResponseTooLarge];
        }
    }
    else 
    {
        if (_dataAccumulator.length + data.length > _lastResponse.expectedContentLength)
        {
            [self failWithError:OperationErrorResponseTooLarge];
        }
        else
        {
            [_dataAccumulator appendData:data];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _responseBody = _dataAccumulator;
    _dataAccumulator = nil;
    
    // Because we fill out _dataAccumulator lazily, an empty body will leave _dataAccumulator 
    // set to nil.  That's not what our clients expect, so we fix it here.
    
    if (_responseBody == nil) {
        _responseBody = [[NSData alloc] init];
    }
    
    if (!self.isResponseCodeAcceptable) 
    {
        [self failWithError:OperationErrorBadResponseCode];
    } 
    else if (!self.isContentTypeAcceptable) 
    {
        [self failWithError:OperationErrorBadContentType];
    }
    else
    {
        [self willChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        _operationState = OperationStateSuccess;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
    }
}

-(void)connection:(NSError*)conn didFailWithError:(NSError*)error
{
    [[Logging logger] logMessage:error.localizedDescription];
    [self failWithError:OperationErrorConnectionError];
}

#pragma error handling 

-(NSString*)messageForError:(OperationError)error
{
    NSString* message;
    switch (error) {
        case OperationErrorConnectionError:
            message = @"Connection failed.";
            break;
        case OperationErrorResponseTooLarge:
            message = [NSString stringWithFormat:@"Response too large. %i > %i", _dataAccumulator.length, _maxResponseSize];
            break;
        case OperationErrorBadContentType:
            message = [NSString stringWithFormat:@"Unacceptable Content Type: %@", _lastResponse.MIMEType];
            break;
        case OperationErrorBadResponseCode:
            message = [NSString stringWithFormat:@"Unacceptable Response Code: %i", _lastResponse.statusCode];
            break;
        case OperationErrorUnexpectedResponseSize:
            message = [NSString stringWithFormat:@"Response size different than expected. Expected %i", _lastResponse.expectedContentLength];
            break;
        default:
            assert(NO); // make sure errors aren't falling through the cracks
    }
    return message;
}

-(void)failWithError:(OperationError)error
{
    [[Logging logger] logMessage:[self messageForError:error]];
    [super failWithError:error];
}

#pragma support methods

-(BOOL)isContentTypeAcceptable
{
    if (_lastResponse.MIMEType == nil)
    {
        return NO;
    }
    
    // default is all types acceptable
    if (_acceptableContentTypes == nil)
    {
        return YES;
    }
    
    return [_acceptableContentTypes containsObject:_lastResponse.MIMEType];
}

-(BOOL)isResponseCodeAcceptable
{
    if (_lastResponse.MIMEType <= 0)
    {
        return NO;
    }
    
    return [_acceptableStatusCodes containsIndex:_lastResponse.statusCode];
}


@end
