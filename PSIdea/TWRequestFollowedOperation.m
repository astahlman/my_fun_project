//
//  TWRequestFollowedOperation.m
//  PSIdea
//
//  Created by Andrew Stahlman on 4/11/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "TWRequestFollowedOperation.h"
#import "Logging.h"
#import "HTTPSynchOperation.h"

@implementation TWRequestFollowedOperation

@synthesize followed = _followed;

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
             
             if ([accountsArray count] > 0 && _handle != nil) 
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
         else
         {
             [[Logging logger] logMessage:[NSString stringWithFormat:@"Error retrieving account: %@", [error description]]];
             [self failWithError:OperationErrorOther];
         }
         
         if (twitterAccount != nil)
         {
             TWRequest* followedRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/friends/ids.json"] parameters:[NSDictionary dictionaryWithObject:_handle forKey:@"screen_name"] requestMethod:TWRequestMethodGET];             [followedRequest setAccount:twitterAccount];
             
             [followedRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
              {
                  _responseDict = [_jsonParser objectWithData:responseData];
                  [[Logging logger] logMessage:[NSString stringWithFormat:@"Here is the tweet responseData: %@", _responseDict]];
                  
                  NSIndexSet* acceptableCodes = [HTTPSynchOperation defaultAcceptableStatusCodes];
                  if (![acceptableCodes containsIndex:[urlResponse statusCode]])
                  {
                      [[Logging logger] logMessage:[NSString stringWithFormat:@"Failed to post tweet: response code %i", [urlResponse statusCode]]];
                      [self failWithError:OperationErrorBadResponseCode];
                  }
                  else
                  {
                      NSArray* userIds = [_responseDict valueForKey:@"ids"];
                      NSString* idString = [[NSString alloc] init];
                      for (NSString* userId in userIds)
                      {
                          idString = [idString stringByAppendingFormat:@"%@, ", userId];
                      }
                      idString = [idString substringToIndex:([idString length] - 2)];
                      TWRequest* screenNameRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/users/lookup.json"] parameters:[NSDictionary dictionaryWithObject:idString forKey:@"user_id"] requestMethod:TWRequestMethodGET];
                      [screenNameRequest performRequestWithHandler:^(NSData *innerResponseData, NSHTTPURLResponse *innerUrlResponse, NSError *innerError) 
                       {
                           NSDictionary* innerResponseDict = [_jsonParser objectWithData:innerResponseData];
                           NSIndexSet* acceptableCodes = [HTTPSynchOperation defaultAcceptableStatusCodes];
                           if (![acceptableCodes containsIndex:[urlResponse statusCode]])
                           {
                               [[Logging logger] logMessage:[NSString stringWithFormat:@"Failed to post tweet: response code %i", [innerUrlResponse statusCode]]];
                               [self failWithError:OperationErrorBadResponseCode];
                           }
                           else
                           {
                               NSMutableArray* screenNames = [[NSMutableArray alloc] init];
                               for (NSDictionary* user in innerResponseDict)
                               {
                                   NSString* screenName = [user valueForKey:@"screen_name"];
                                   
                                   // strip the enclosing "" if necessary
                                   int length = [screenName length];
                                   if ([screenName characterAtIndex:0] == '\"' && [screenName characterAtIndex:length - 1] =='"')
                                   {
                                       screenName = [screenName substringWithRange:NSMakeRange(1, length - 3)];
                                   }
                                   
                                   [screenNames addObject:screenName];
                               }
                               [self setFollowed:[NSArray arrayWithArray:screenNames]];
                               [_responseDict setValue:self.followed forKey:@"screenNames"];
                               [self onOperationSuccess];
                           }
                       }];
                  }
                  
              }];
         }
         else 
         {
             [[Logging logger] logMessage:[NSString stringWithFormat:@"Account %@ does not exist on this device.", _handle]];
             [self failWithError:OperationErrorOther];
         }
     }];  
    
    while (_operationState == OperationStateExecuting)
    {
        // spin wait on our block methods to complete
        // TODO: There must be a more efficient way to do this...
    }
}

@end
