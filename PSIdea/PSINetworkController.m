//
//  PSINetworkController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 1/23/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "PSINetworkController.h"
#import "NSObject+PropertyArray.h"

@implementation PSINetworkController

@synthesize baseUrl = _baseUrl;
@synthesize delegate = _delegate;
@synthesize jsonWriter = _jsonWriter;
@synthesize jsonParser = _jsonParser;

+(PSINetworkController*)PSINetworkControllerWithBaseURL:(NSURL*)baseUrl {
    PSINetworkController* controller = [super networkControllerWithBaseURL:baseUrl];
    return controller;
}

-(id)initWithBaseUrl:(NSURL *)baseUrl
{
    self = [super initWithBaseUrl:baseUrl];
    if (self) {
        // custom init
    }
    return self;
}
-(void)retrieveObjectForId:(NSString*)idString atRelUrl:(NSString*)relUrl
{
    relUrl = [relUrl stringByAppendingString:idString];
    NSURL* url = [NSURL URLWithString:relUrl relativeToURL:_baseUrl];
    [self sendRequestForURL:url];
}

-(void)postRequestAtRelUrl:(NSString*)relUrl withPostData:(NSDictionary*)postDict
{
    NSString* postData = @"";
    for (id key in postDict)
    {
        NSString* appended = [NSString stringWithFormat:@"%@=%@&", key, [postDict objectForKey:key]];
        postData = [postData stringByAppendingString:appended];
    }
    postData = [postData substringToIndex:postData.length - 1]; //remove the final '&'
    NSData* data = [postData dataUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:relUrl relativeToURL:_baseUrl];
    [self postRequestToURL:url withData:data withContentType:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSLog(@"didFinishLoading: responseData length:(%d)", _responseData.length);
    NSString *responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseData as string: %@", responseString);
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    /*
     NSArray* objs = [parser objectWithData:_responseData];
    NSLog(@"responseData as dictionary:");
    NSDictionary* theDict = [NSDictionary alloc];
    for (NSDictionary* dict in objs)
    {
        for (id key in dict) {
            NSLog(@"%@=%@", key, [dict objectForKey:key]);
            theDict = dict;
        }
    }
     */
    [_delegate connection:connection receivedResponse:responseString];
}

-(void)postPoi:(POI*)poi 
{
    NSDictionary *properties = [poi dictionaryWithValuesForKeys:[poi allKeys]];
    NSMutableDictionary *editedProps = [NSMutableDictionary dictionaryWithDictionary:properties];
    [editedProps removeObjectForKey:@"creator"];
    [editedProps removeObjectForKey:@"lists"];
    NSLog(@"properties Dictionary:");
    for (id key in editedProps) {
        NSLog(@"%@=%@", key, [editedProps valueForKey:key]);
    }
    NSError* jsonError = nil;
    NSString* json = [_jsonWriter stringWithObject:editedProps error:&jsonError];
    NSLog(@"json error: %@", jsonError);
    NSLog(@"postPoi: Here is the JSON for the poi: %@", json);
    NSURL* url = [NSURL URLWithString:@"add_poi/" relativeToURL:_baseUrl];
    [self postJSONToURL:url withJson:json];
}

@end
