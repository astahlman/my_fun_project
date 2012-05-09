//
//  TWRequestOperation.m
//  PSIdea
//
//  Created by Andrew Stahlman on 4/5/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "TWRequestOperation.h"
#import "Logging.h"
#import "HTTPSynchOperation.h"

@implementation TWRequestOperation

@synthesize request = _request;
@synthesize responseDict = _responseDict;

-(id)initWithHandle:(NSString *)twitterHandle twRequest:(TWRequest *)request
{
    if (self = [self initWithHandle:twitterHandle])
    {
         _request = request;
    }
           
    return self;
}

-(id)initWithHandle:(NSString*)twitterHandle
{
    self = [super init];
    if (self != nil)
    {
        _handle = twitterHandle;
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
    }

        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        __block ACAccount* twitterAccount = nil;
        
        // Request access from the user to use their Twitter accounts.
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) 
         {
             if(granted) 
             {
                 // Get the list of Twitter accounts.
                 NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                 
                 if ([accountsArray count] > 0) 
                 {
                     if (_handle != nil)
                     {
                         // Grab the initial Twitter account to tweet from.
                         for (ACAccount* acct in accountsArray)
                         {
                             if ([[acct username] isEqualToString:_handle])
                             {
                                 twitterAccount = acct;
                             }
                         }
                     }
                 }
             }
             else
             {
                 [[Logging logger] logMessage:[NSString stringWithFormat:@"Error retrieving account: %@", [error description]]];


                 [self willChangeValueForKey:@"isExecuting"];
                 [self willChangeValueForKey:@"isFinished"];
                 _operationState = OperationStateFailed;
                 [self didChangeValueForKey:@"isExecuting"];
                 [self didChangeValueForKey:@"isFinished"];
             }
             
             if (twitterAccount != nil)
             {

                 [_request setAccount:twitterAccount];
                 
                 [_request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
                  {
                      _responseDict = [_jsonParser objectWithData:responseData];
                      [[Logging logger] logMessage:[NSString stringWithFormat:@"Here is the tweet responseData: %@", _responseDict]];
                      NSIndexSet* acceptableCodes = [HTTPSynchOperation defaultAcceptableStatusCodes];
                      if (![acceptableCodes containsIndex:[urlResponse statusCode]])
                      {
                          [[Logging logger] logMessage:[NSString stringWithFormat:@"Failed to post tweet: response code %i", [urlResponse statusCode]]];
                          [self willChangeValueForKey:@"isExecuting"];
                          [self willChangeValueForKey:@"isFinished"];
                          _operationState = OperationStateFailed;
                          [self didChangeValueForKey:@"isExecuting"];
                          [self didChangeValueForKey:@"isFinished"];
                      }
                      else
                      {
                          [self willChangeValueForKey:@"isExecuting"];
                          [self willChangeValueForKey:@"isFinished"];
                          _operationState = OperationStateSuccess;
                          [self didChangeValueForKey:@"isExecuting"];
                          [self didChangeValueForKey:@"isFinished"];
                      }
                      
                  }];
             }
             else 
             {
                 [[Logging logger] logMessage:[NSString stringWithFormat:@"Account %@ does not exist on this device.", _handle]];
                 [self willChangeValueForKey:@"isExecuting"];
                 [self willChangeValueForKey:@"isFinished"];
                 _operationState = OperationStateFailed;
                 [self didChangeValueForKey:@"isExecuting"];
                 [self didChangeValueForKey:@"isFinished"];
             }
         }];  

    while (_operationState == OperationStateExecuting)
    {
        // spin wait on our block methods to complete
        // TODO: There must be a more efficient way to do this...
    }
}

@end
