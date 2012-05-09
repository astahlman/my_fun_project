//
//  TwitterAPI.m
//  PSIdea
//
//  Created by Andrew Stahlman on 4/5/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "TwitterAPI.h"
#import "HTTPSynchOperation.h"
#import "Logging.h"
#import "TWRequestOperation.h"
#import "TWRequestFollowedOperation.h"

@implementation TwitterAPI

@synthesize networkManager = _networkManager;

+(TwitterAPI*)apiInstance
{
    static TwitterAPI* api;
    if (api == nil)
    {
        @synchronized(self)
        {
            api = [[TwitterAPI alloc] init];
        }
    }
    return api;
}

-(id)init
{
    self = [super init];
    _jsonParser = [[SBJsonParser alloc] init];
    return self;
}

-(void)sendTweet:(NSString*)body forHandle:(NSString *)handle callbackTarget:(id)target action:(SEL)action
{
    TWRequest* postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:body forKey:@"status"] requestMethod:TWRequestMethodPOST];
    TWRequestOperation* twOp = [[TWRequestOperation alloc] initWithHandle:handle twRequest:postRequest];
    [_networkManager addNetworkTransferOperation:twOp finishedTarget:target action:action];
}

-(void)getFollowed:(NSString*)handle callbackTarget:(id)target action:(SEL)action
{
    // for now, we only get up to the first 5000
    TWRequestFollowedOperation* getFollowedOp = [[TWRequestFollowedOperation alloc] initWithHandle:handle];
    [_networkManager addNetworkTransferOperation:getFollowedOp finishedTarget:target action:action];
}

+(void) getCurrentUser {
    
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                [[NSUserDefaults standardUserDefaults] setValue:twitterAccount.username forKey:@"twitterHandle"];
                NSURL *url =
                [NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:twitterAccount.username forKey:@"screen_name"];
                [params setObject:@"bigger" forKey:@"size"];
                
                TWRequest *request = [[TWRequest alloc] initWithURL:url
                                                         parameters:params
                                                      requestMethod:TWRequestMethodGET];
                
                [request performRequestWithHandler:
                 ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     if (responseData) {
                         NSDictionary *user =
                         [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:NSJSONReadingAllowFragments
                                                           error:NULL];
                         
                         NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
                         [[NSUserDefaults standardUserDefaults] setValue:[user objectForKey:@"name"] forKey:@"name"];                         //  As an example we could set an image's content to the image
                         dispatch_async
                         (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                             NSData *imageData =
                             [NSData dataWithContentsOfURL:
                              [NSURL URLWithString:profileImageUrl]];
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [[NSUserDefaults standardUserDefaults] setValue:imageData forKey:@"userPhoto"];
                                 
                             });
                         });
                     }
                 }];                
            }
        }
    }];
    
}

@end
