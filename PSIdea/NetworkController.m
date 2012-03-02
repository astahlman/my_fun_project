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

static NSDictionary* contentTypeDict = nil;

-(void)setResponseData:(NSMutableData*)data
{
    _responseData = data;
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
        contentTypeDict = [NetworkController getContentTypeDictionary];
    }
    return self;
}

-(NSURL*)appendURLToBase:(NSString *)relURL
{
    return [NSURL URLWithString:relURL relativeToURL:self.baseUrl];
}

+(NSDictionary*)contentTypeDict
{
    return contentTypeDict;
}

+(NSDictionary*)getContentTypeDictionary
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"JSON", @"application/x-www-form-urlencoded", @"default", nil];
    return dict;
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

+(NSData*)dataFromJSONString:(NSString*)jsonString
{
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSData*)dataFromDictionary:(NSDictionary*)dataDict 
{
    NSString* dataString = [NetworkController requestStringFromDictionary:dataDict];
    return [dataString dataUsingEncoding:NSUTF8StringEncoding];
}

-(void)requestForURL:(NSURL*)url 
{
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)getRequestAtUrl:(NSURL*)url withGetData:(NSDictionary*)dict
{
    NSString* queryString = [NetworkController requestStringFromDictionary:dict];
    NSURL* queryURL = [url URLByAppendingPathExtension:queryString];
    [self requestForURL:queryURL];
}

-(void)postRequestToURL:(NSURL*)url withData:(NSData*)data withContentType:(NSString*)contentType 
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    if (!contentType)
    {
        contentType = [contentTypeDict valueForKey:@"default"];
    }
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
