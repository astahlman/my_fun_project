//
//  TwitterAPI.h
//  PSIdea
//
//  Created by Andrew Stahlman on 4/5/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "SBJson.h"
#import "NetworkManager.h"

@interface TwitterAPI : NSObject
{
    SBJsonParser* _jsonParser;
    NetworkManager* _networkManager;
}

@property (nonatomic, retain) NetworkManager* networkManager;

// singleton
+(TwitterAPI*)apiInstance;
+(void) getCurrentUser;

-(id)init;
-(void)sendTweet:(NSString*)body forHandle:(NSString *)handle callbackTarget:(id)target action:(SEL)action;
-(void)getFollowed:(NSString*)handle callbackTarget:(id)target action:(SEL)action;
@end
