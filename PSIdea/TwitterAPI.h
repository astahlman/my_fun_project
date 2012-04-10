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

@interface TwitterAPI : NSObject
{
    SBJsonParser* _jsonParser;
}
// singleton
+(TwitterAPI*)apiInstance;
+(void) getCurrentUser;

-(id)init;
-(void)sendTweet:(NSString*)body forHandle:(NSString*)handle;

@end
