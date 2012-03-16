//
//  NetworkAPI.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/7/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "POI.h"
#import "User.h"
#import "SBJson.h"
#import "HTTPSynchOperation.h"
#import "HTTPSynchPostOperationWithParse.h"
#import "HTTPSynchGetOperationWithParse.h"


extern const NSString* PSI_URL_BASE;

@interface NetworkAPI : NSObject
{
    NetworkManager* _networkManager;
    SBJsonParser* _jsonParser;
    SBJsonWriter* _jsonWriter;
}


// singleton
+(NetworkAPI*)apiInstance;

+(NSData*)dataFromDictionary:(NSDictionary*)dataDict;
+(NSData*)dataFromJSONString:(NSString*)jsonString;
+(NSString*)requestStringFromDictionary:(NSDictionary*)dict;

-(void)postPOI:(POI *)poi callbackTarget:(id)target action:(SEL)action;
-(void)getPOIsWithinRadius:(NSUInteger)radius ofLat:(NSNumber*)lat ofLon:(NSNumber*)lon callbackTarget:(id)target action:(SEL)action;
/*
-(void)postUser:(User*)user delegate:(id<HTTPPostOperationDelegate>)delegate;;
-(void)getPOIsWithinRadius:(NSUInteger*)radius ofLat:(NSNumber*)lat ofLon:(NSNumber*)lon delegate:(id<HTTPPostOperationDelegate>)delegate;
-(void)getPOIsForUser:(NSString*)twitterHandle delegate:(id<HTTPPostOperationDelegate>)delegate;;
-(void)getUserForTwitterHandle:(NSString*)twitterHandle delegate:(id<HTTPPostOperationDelegate>)delegate;;
-(void)sendTweet:(NSString*)tweetBody forUser:(NSString*)twitterHandle delegate:(id<HTTPPostOperationDelegate>)delegate;;
-(void)doQuery:(NSString*)query onClasses:(NSArray*)classes delegate:(id<HTTPPostOperationDelegate>)delegate;;
*/
@end
