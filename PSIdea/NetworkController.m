//
//  NetworkController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 1/23/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

@synthesize delegate = _delegate;
@synthesize baseUrl = _baseUrl;
@synthesize jsonParser = _jsonParser;
@synthesize jsonWriter = _jsonWriter;

-(void)setResponseData:(NSMutableData*)data
{
    _responseData = data;
}

+(NetworkController*)networkControllerWithBaseURL:(NSURL*)baseUrl
{
    NetworkController* controller = [[NetworkController alloc] init];
    if (controller) {
        [controller setResponseData:[NSMutableData data]];
        [controller setJsonParser:[[SBJsonParser alloc] init]];
        [controller setJsonWriter:[[SBJsonWriter alloc] init]];
    }
    return controller;
}

-(id)initWithBaseUrl:(NSURL*)baseUrl
{
    self = [super init];
    if (self) 
    {
        self.baseUrl = baseUrl;
        _responseData = [NSMutableData data];
        self.jsonParser = [[SBJsonParser alloc] init];
        self.jsonWriter = [[SBJsonWriter alloc] init];
    }
    return self;
}

-(void)sendRequestForURL:(NSURL*)url 
{
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)postRequestToURL:(NSURL*)url withData:(NSData*)data withContentType:(NSString*)contentType 
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    if (!contentType)
    {
        contentType = @"application/x-www-form-urlencoded";
    }
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)postJSONToURL:(NSURL*)url withJson:(NSString*)jsonString
{
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* contentType = @"application/json";
    [self postRequestToURL:url withData:data withContentType:contentType];
}

-(void)connection:(NSConnection*)conn didReceiveData:(NSData*)data 
{
    [_responseData appendData:data];
    NSLog(@"didReceiveData. responseData length:(%d)", _responseData.length);
    NSString *responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseData as string: %@", responseString);
}

-(void)connection:(NSConnection*)conn didReceiveResponse:(NSURLResponse *)response 
{
    if (_responseData == nil) {
        _responseData = [NSMutableData data];
    }
    [_responseData setLength:0];
    NSLog(@"didReceiveResponse: responseData length:(%d)", _responseData.length);
}


-(void)connection:(NSConnection*)conn didFailWithError:(NSError *)error 
{
    NSLog([NSString stringWithFormat:@"Connection failed: %@", error.description]);
}


@end
