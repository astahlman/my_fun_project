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
#import "Logging.h"

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
        [[Logging logger] logMessage:[NSString stringWithFormat:@"Error writing JSON for POI: %@", jsonError]];
    }
    else 
    {
        [[Logging logger] logMessage:[NSString stringWithFormat:@"postPoi: Here is the JSON for the poi: %@", json]];
    }

    NSString* urlString = [NSString stringWithFormat:@"%@/%@/", PSI_URL_BASE, @"poi"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    HTTPSynchPostOperationWithParse* op = [[HTTPSynchPostOperationWithParse alloc] initWithRequest:request postEntity:poi];
    [_networkManager addNetworkTransferOperation:op finishedTarget:target action:action];
}

-(void)getPOIsWithinRadius:(NSUInteger)radius ofLat:(NSNumber*)lat ofLon:(NSNumber*)lon callbackTarget:(id)target action:(SEL)action managedObjectContext:(NSManagedObjectContext*)moc
{
    NSArray* objects = [NSArray arrayWithObjects:[NSNumber numberWithInteger:radius], lat, lon, nil];
    NSArray* keys = [NSArray arrayWithObjects:@"radius", @"latitude", @"longitude", nil];
    NSDictionary* locationDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", PSI_URL_BASE, @"local_poi", [[self class] requestStringFromDictionary:locationDict]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    HTTPSynchGetOperationWithParse* op = [[HTTPSynchGetOperationWithParse alloc] initWithRequest:request managedObjectContext:moc];
    [_networkManager addNetworkTransferOperation:op finishedTarget:target action:action];
}

-(void)postUser:(User*)user callbackTarget:(id)target action:(SEL)action
{
    NSDictionary* userDict = [NSDictionary dictionaryWithObject:[user twitterHandle] forKey:@"twitterHandle"];
    NSError* jsonError;
    NSString* json = [_jsonWriter stringWithObject:userDict error:&jsonError];
    NSData* data = [[self class] dataFromJSONString:json];
    if (jsonError != nil)
    {
        [[Logging logger] logMessage:[NSString stringWithFormat:@"Error writing JSON for postUser request: %@", jsonError]];
    }
    else 
    {
        [[Logging logger] logMessage:[NSString stringWithFormat:@"postUser: Here is the JSON for the request: %@", json]];
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/%@/", PSI_URL_BASE, @"user"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    HTTPSynchPostOperationWithParse* op = [[HTTPSynchPostOperationWithParse alloc] initWithRequest:request postEntity:user];
    [_networkManager addNetworkTransferOperation:op finishedTarget:target action:action];
}

-(void)getPOIsForUser:(User*)user callbackTarget:(id)target action:(SEL)action managedObjectContext:(NSManagedObjectContext*)moc
{
    NSArray* objects = [NSArray arrayWithObject:[user twitterHandle]];
    NSArray* keys = [NSArray arrayWithObject:@"twitterHandle"];
    NSDictionary* locationDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", PSI_URL_BASE, @"user_poi", [[self class] requestStringFromDictionary:locationDict]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    HTTPSynchGetOperationWithParse* op = [[HTTPSynchGetOperationWithParse alloc] initWithRequest:request managedObjectContext:moc];
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
        id value = [dict objectForKey:key];

        NSString* append = [NSString stringWithFormat:@"%@=%@&", key, value];

        queryString = [queryString stringByAppendingString:append];
    }
    queryString = [queryString substringToIndex:queryString.length - 1]; //remove the final '&'
    return queryString;
}

@end
