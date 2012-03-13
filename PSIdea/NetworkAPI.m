//
//  NetworkAPI.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/7/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NetworkAPI.h"
#import "HTTPSynchGetOperationWithParse.h"
#import "HTTPSynchPostOperationWithParse.h"
#import "NSManagedObject+PropertiesDict.h"
#import "CoreDataManager.h"

const NSString* PSI_URL_BASE = @"http://127.0.0.1:8000";

@implementation NetworkAPI

+(NetworkAPI*)apiInstance
{
    static NetworkAPI* api;
    if (api == nil)
    {
        @synchronized(self)
        {
            api = [[NetworkAPI alloc] init];
        }
    }
    return api;
}

-(id)init
{
    self = [super init];
    _networkManager = [[NetworkManager alloc] init];
    _jsonParser = [[SBJsonParser alloc] init];
    _jsonWriter = [[SBJsonWriter alloc] init];
    return self;
}

@class HTTPPostOperationDelegate;

-(void)postPOI:(POI *)poi callbackTarget:(id)target action:(SEL)action;   
{
    NSMutableDictionary* poiDict = [[NSMutableDictionary alloc] initWithDictionary:[poi propertiesDict]];
    [poiDict addEntriesFromDictionary:[poi relationshipsDict]];
    NSError* jsonError = nil;
    NSString* json = [_jsonWriter stringWithObject:poiDict error:&jsonError];
    NSData* data = [[self class] dataFromJSONString:json];
    if (jsonError != nil)
    {
        NSLog(@"Error writing JSON for POI: %@", jsonError);
    }
    else 
    {
        NSLog(@"postPoi: Here is the JSON for the poi: %@", json);
    }

    NSString* urlString = [NSString stringWithFormat:@"%@/%@/", PSI_URL_BASE, @"poi"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    HTTPSynchPostOperationWithParse* op = [[HTTPSynchPostOperationWithParse alloc] initWithRequest:request postEntity:poi];
    [_networkManager addNetworkTransferOperation:op finishedTarget:target action:action];
}



#pragma JSON/URL support methods 
+(NSData*)dataFromJSONString:(NSString*)jsonString
{
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSData*)dataFromDictionary:(NSDictionary*)dataDict 
{
    NSString* dataString = [[self class] requestStringFromDictionary:dataDict];
    return [dataString dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSString*)requestStringFromDictionary:(NSDictionary*)dict 
{
    NSString* queryString = @"?";
    for (id key in dict)
    {
        NSString* append = [NSString stringWithFormat:@"%@=%@&", key, [dict objectForKey:key]];
        queryString = [queryString stringByAppendingString:append];
    }
    queryString = [queryString substringToIndex:queryString.length - 1]; //remove the final '&'
    return queryString;
}

@end
