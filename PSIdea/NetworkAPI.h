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
#import "HTTPOperation.h"
#import "SBJson.h"

@protocol NetworkAPIDelegate <NSObject>
// eliminate the other 3?
//-(void)operation:(NSOperation*)operation didParseResults:(NSArray*)entitites
-(void)operation:(NSOperation*)operation didRetrievePOIs:(NSArray*)pois;
-(void)operation:(NSOperation*)operation didRetrieveUsers:(NSArray*)users;
-(void)operation:(NSOperation*)operation didRetrieveQueryResults:(NSArray*)results;
-(void)operation:(NSOperation*)operation didFailWithError:(NSString*)errorMsg;

@end

const NSString* URL_BASE = @"http://127.0.0.1:8000";

@interface NetworkAPI : NSObject
{
    NetworkManager* _networkManager;
    SBJsonParser* _jsonParser;
    SBJsonWriter* _jsonWriter;
}

@property (nonatomic, retain) id<NetworkAPIDelegate> delegate;

// singleton
+(NetworkAPI*)apiInstance;

+(NSData*)dataFromDictionary:(NSDictionary*)dataDict;
+(NSData*)dataFromJSONString:(NSString*)jsonString;
+(NSString*)requestStringFromDictionary:(NSDictionary*)dict;

-(void)httpOperationDidFinish:(HTTPOperation*)operation;

-(void)postPOI:(POI*)poi;
-(void)postUser:(User*)user;
-(void)getPOIsWithinRadius:(NSUInteger*)radius ofLat:(NSNumber*)lat ofLon:(NSNumber*)lon;
-(void)getPOIsForUser:(NSString*)twitterHandle;
-(void)getUserForTwitterHandle:(NSString*)twitterHandle;
-(void)sendTweet:(NSString*)tweetBody forUser:(NSString*)twitterHandle;
-(void)doQuery:(NSString*)query onClasses:(NSArray*)classes;

@end
