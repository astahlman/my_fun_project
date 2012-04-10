//
//  TwitterController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/3/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "TwitterController.h"
#import "SBJsonParser.h"

@implementation TwitterController

@synthesize account = _account;

-(id)init
{
    self = [[self class] init];
    //  First, we need to obtain the account instance for the user's Twitter account
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = 
    [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request access from the user for access to his Twitter accounts
    [store requestAccessToAccountsWithType:twitterAccountType 
                     withCompletionHandler:^(BOOL granted, NSError *error) {
                         if (!granted) {
                             // The user rejected your request 
                             NSLog(@"User rejected access to his account.");
                         } 
                         else {
                             // Grab the available accounts
                             NSArray *twitterAccounts = 
                             [store accountsWithAccountType:twitterAccountType];
                             
                             if ([twitterAccounts count] > 0) {
                                 // Use the first account for simplicity 
                                 _account = [twitterAccounts objectAtIndex:0];
                             }
                         }
                     }];
     return self;
}

-(void)sendTweet:(NSString*)tweetBody
{
    NSURL* url = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:tweetBody forKey:@"status"];
    TWRequest *request = 
    [[TWRequest alloc] initWithURL:url 
                        parameters:params 
                     requestMethod:TWRequestMethodPOST];
    [request setAccount:_account];
    
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         if (!responseData) {
             // inspect the contents of error 
             NSLog(@"Error: %@", error);
         } 
         else {
             SBJsonParser* parser = [[SBJsonParser alloc] init];
             NSLog(@"Success: %@, %@", urlResponse, [parser objectWithData:responseData]);
         }
     }];
    
}

@end
