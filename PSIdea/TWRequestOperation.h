//
//  TWRequestOperation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 4/5/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NSOperationWithState.h"
#import <Twitter/Twitter.h>
#import "SBJson.h"

@interface TWRequestOperation : NSOperationWithState
{
    TWRequest* _request;
    SBJsonParser* _jsonParser;
}

@property (nonatomic, retain) TWRequest* request;

-(id)initWithRequest:(TWRequest*)request;

-(void)cancel;
-(BOOL)isExecuting;
-(BOOL)isFinished;
-(BOOL)isConcurrent;

@end
