//
//  PSINetworkController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 1/23/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "PSINetworkController.h"
#import "NSObject+PropertyArray.h"
#import "POI.h"
#import "User.h"
#import "List.h"
#import "Photo.h"

@implementation PSINetworkController

@synthesize baseUrl = _baseUrl;
@synthesize delegate = _delegate;
@synthesize jsonWriter = _jsonWriter;
@synthesize jsonParser = _jsonParser;

static NSDictionary* modelDict = nil;
static NSDictionary* poiMappingDict = nil;

-(id)initWithBaseUrl:(NSURL *)baseUrl
{
    self = [super initWithBaseUrl:baseUrl];
    if (self) {
        // custom init
    }
    return self;
    modelDict = [PSINetworkController getModelDictionary];
    poiMappingDict = [PSINetworkController getPOIMappingDictionary];
}

+(NSDictionary*)getModelDictionary
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[POI class], @"pois.poi", [User class], @"pois.user", [List class], @"pois.list", [Photo class], @"pois.photo", nil];
    return dict;
}

+(NSDictionary*)getPOIMappingDictionary
{
    NSArray* objects = [NSArray arrayWithObjects:@"creationDate", @"details", @"latitude", @"longitude", @"rating", @"tags", @"title", nil];
    NSArray* keys = [NSArray arrayWithObjects:@"creationDate", @"details", @"latitude", @"longitude", @"rating", @"tags", @"title", nil];
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    return dict;
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSLog(@"didFinishLoading: responseData length:(%d)", _responseData.length);
    NSString *responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseData as string: %@", responseString);
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    NSError* parserError = nil;
    NSArray* responseObjects = [parser objectWithString:responseString error:&parserError];
    for (id dict in responseObjects)
    {
        id theClass = [dict valueForKey:@"model"];
        if (theClass == [POI class])
        {
            //POI* poi = [self parsePOI:dict];
        }
        
    }
    [_delegate connection:connection receivedResponse:responseString];
}

-(void)retrieveObjectForId:(NSString*)idString atRelUrl:(NSString*)relUrl
{
    relUrl = [relUrl stringByAppendingString:idString];
    NSURL* url = [NSURL URLWithString:relUrl relativeToURL:_baseUrl];
    [self requestForURL:url];
}

-(void)postPoi:(POI*)poi 
{
    NSDictionary* propDict = [poi propertiesDict];
    NSError* jsonError = nil;
    NSString* json = [_jsonWriter stringWithObject:propDict error:&jsonError];
    NSData* data = [NetworkController dataFromJSONString:json];
    if (jsonError != nil)
    {
        NSLog(@"json error: %@", jsonError);
    }
    else 
    {
        NSLog(@"postPoi: Here is the JSON for the poi: %@", json);
    }
    NSURL* url = [self appendURLToBase:@"poi/"];
    [self postRequestToURL:url withData:data withContentType:[[NetworkController contentTypeDict] valueForKey:@"JSON"]];
}

-(void)requestPoi:(NSString *)idString
{
    NSURL* url = [self appendURLToBase:@"poi"];
    NSDictionary* requestDict = [NSDictionary dictionaryWithObjectsAndKeys:idString, @"id", nil];
    [self getRequestAtUrl:url withGetData:requestDict];
}

-(POI*)parsePoi:(NSDictionary*)poiDict
{
    POI* poi = [[POI alloc] init];
    NSString* pkString = [poiDict valueForKey:@"pk"];
    poi.idNumber = [NSNumber numberWithInteger:[pkString integerValue]];
}

@end
