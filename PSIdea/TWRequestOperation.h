//
//  TWRequestOperation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 4/5/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NSOperationWithState.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "SBJson.h"

@interface TWRequestOperation : NSOperationWithState
{
    TWRequest* _request;
    NSString* _handle;
    SBJsonParser* _jsonParser;
    __block NSDictionary* _responseDict;
}

@property (nonatomic, retain) TWRequest* request;
@property (nonatomic, retain) NSDictionary* responseDict;

-(id)initWithHandle:(NSString*)twitterHandle;
-(id)initWithHandle:(NSString*)twitterHandle twRequest:(TWRequest*)request;

-(void)cancel;
-(BOOL)isExecuting;
-(BOOL)isFinished;
-(BOOL)isConcurrent;

@end
