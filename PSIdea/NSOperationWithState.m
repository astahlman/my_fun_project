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

+(NSIndexSet*)defaultAcceptableStatusCodes
{
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 99)];
}

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

-(NSString*)messageForError:(OperationError)error
{
    NSString* msg;
    switch (error) {
        case OperationErrorBadContentType:
            msg = @"Response indicates invalid content type.";
            break;
        case OperationErrorBadResponseCode:
            msg = @"Response code invalid.";
            break;
        case OperationErrorConnectionError:
            msg = @"Connection failed.";
            break;
        case OperationErrorResponseTooLarge:
            msg = @"Response was too large.";
            break;
        case OperationErrorUnexpectedResponseSize:
            msg = @"Actual response size was different than expected";
            break;
        case OperationErrorJSONParsingError:
            msg = @"Couldn't parse the response as valid JSON.";
            break;
        default:
            assert(NO); // don't let errors fall through the cracks
            break;
    }
    return msg;
}

@end
