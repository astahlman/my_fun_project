//
//  NetworkAPI.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/7/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NetworkAPI.h"

@interface NetworkAPI()
-(void)doSomething;
@end

@implementation NetworkAPI

@synthesize delegate = _delegate;

+(NetworkAPI*)apiInstance
{
    static NetworkAPI* api;
    if (api == nil)
    {
        api = [[NetworkAPI alloc] init];
    }
    return api;
}

-(id)init
{
    self = [super init];
    _networkManager = [[NetworkManager alloc] init];
    return self;
}

-(void)postPOI:(POI *)poi
{
    NSDictionary* propDict = [poi propertiesDict];
    NSError* jsonError = nil;
    NSString* json = [_jsonWriter stringWithObject:propDict error:&jsonError];
    NSData* data = [[self class] dataFromJSONString:json];
    if (jsonError != nil)
    {
        NSLog(@"Error writing JSON for POI: %@", jsonError);
    }
    else 
    {
        NSLog(@"postPoi: Here is the JSON for the poi: %@", json);
    }
    NSString* urlString = [NSString stringWithFormat:@"%@/%@/", URL_BASE, @"poi"];
    NSMutableURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    HTTPOperation* op = [[HTTPOperation alloc] initWithRequest:request];
    [_networkManager addNetworkTransferOperation:op finishedTarget:self action:(SEL)@"queueParseOperation:"];
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
