//
//  HTTPSynchPostOperationWithParse.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/13/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPSynchPostOperationWithParse.h"
#import "Logging.h"

@implementation HTTPSynchPostOperationWithParse 

@synthesize jsonParser = _jsonParser;
@synthesize jsonWriter = _jsonWriter;
@synthesize postEntity = _postEntity;


-(id)initWithRequest:(NSURLRequest*)request postEntity:(NSManagedObject*)entity;
{
    self = [super initWithRequest:request];
    _postEntity = entity;
    _jsonWriter = [[SBJsonWriter alloc] init];
    _jsonParser = [[SBJsonParser alloc] init];
    return self;
}

-(id)copyWithZone:(NSZone*)zone
{
    HTTPSynchPostOperationWithParse* clone = [super copyWithZone:zone];
    [clone setPostEntity:_postEntity];
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
        [self finishPostOperation];
        
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

-(void)finishPostOperation
{
    NSString* dataString = [[NSString alloc] initWithData:_responseBody encoding:NSUTF8StringEncoding];
    NSError* parseError;
    NSDictionary* responseDict = [_jsonParser objectWithString:dataString error:&parseError];
    responseDict = [_jsonParser objectWithData:_responseBody];
    if (parseError == nil)
    {
        if ([responseDict valueForKey:@"twitterHandle"] != nil)
        {
            NSString* handle = [responseDict valueForKey:@"twitterHandle"];
            [_postEntity setValue:handle forKey:@"twitterHandle"];
        }
        else if ([responseDict valueForKey:@"idNumber"] != nil)
        {
            NSNumber* idNum = [responseDict valueForKey:@"idNumber"];
            [_postEntity setValue:idNum forKey:@"idNumber"];
        }
        else if ([responseDict valueForKey:@"url"] != nil)
        {
            NSURL* theURL = [NSURL URLWithString:[responseDict valueForKey:@"url"]];
            [_postEntity setValue:theURL forKey:@"url"];
        }
        else
        {
            [[Logging logger] logMessage:[NSString stringWithFormat:@"Received invalid primary key data: %@", responseDict]];
            [self failWithError:OperationErrorJSONParsingError];
        }
    }
    else
    {
        [[Logging logger] logMessage:[NSString stringWithFormat:@"Couldn't parse primary key: %@", parseError.description]];
        [self failWithError:OperationErrorJSONParsingError];
    }

}

@end
