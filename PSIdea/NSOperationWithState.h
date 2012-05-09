//
//  NSOperationWithState.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/8/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum OperationError {
    OperationErrorNone,
    OperationErrorConnectionError,
    OperationErrorResponseTooLarge,
    OperationErrorBadResponseCode,
    OperationErrorBadContentType,
    OperationErrorUnexpectedResponseSize,
    OperationErrorJSONParsingError,
    OperationErrorOther,
} OperationError;

typedef enum OperationState {
    OperationStateNotStarted,
    OperationStateExecuting,
    OperationStateCancelled,
    OperationStateFailed,
    OperationStateSuccess,
} OperationState;

@interface NSOperationWithState : NSOperation
{
    OperationState _operationState;
    OperationError _operationError;
    NSNumber* _operationID;
}

@property (nonatomic, readonly) OperationState operationState;
@property (nonatomic, readonly) OperationError operationError;
@property (nonatomic, readonly, retain) NSNumber* operationID;

+(NSIndexSet*)defaultAcceptableStatusCodes;
-(id)init;
-(NSString*)messageForError:(OperationError)error;
-(void)failWithError:(OperationError)error;
-(void)onOperationSuccess;
@end
