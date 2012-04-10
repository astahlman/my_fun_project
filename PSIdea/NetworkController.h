//
//  NetworkController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 1/23/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@protocol NetworkControllerDelegate <NSObject>

-(void)connection:(NSURLConnection*)connection receivedResponse:(id)response;

@end

@interface NetworkController : NSObject
{
    NSMutableData* _responseData;
}

@property (nonatomic, retain) id<NetworkControllerDelegate> delegate;
@property (nonatomic, retain) NSURL* baseUrl;
@property (retain) SBJsonParser* jsonParser;
@property (retain) SBJsonWriter* jsonWriter;

+(NSDictionary*)contentTypeDict;

+(NSDictionary*)getContentTypeDictionary;
+(NSString*)requestStringFromDictionary:(NSDictionary*)dict;
+(NSData*)dataFromJSONString:(NSString*)jsonString;
+(NSData*)dataFromDictionary:(NSDictionary*)dataDict;

-(id)initWithBaseUrl:(NSURL*)baseUrl;
-(NSURL*)appendURLToBase:(NSString*)relURL;
-(void)requestForURL:(NSURL*)url;
-(void)postRequestToURL:(NSURL*)url withData:(NSData*)data withContentType:(NSString*)contentType;
-(void)getRequestAtUrl:(NSURL*)url withGetData:(NSDictionary*)dict;

-(void)connection:(NSURLConnection*)conn didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection*)conn didReceiveResponse:(NSURLResponse *)response;
-(void)connection:(NSURLConnection*)conn didFailWithError:(NSError *)error;


@end
