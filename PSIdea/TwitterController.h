//
//  TwitterController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/3/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface TwitterController : NSObject

@property (nonatomic, retain) ACAccount* account;

-(id)init;
-(void)sendTweet:(NSString*)tweetBody;

@end
