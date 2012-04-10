//
//  HTTPOperation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/6/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Networking.h"

@class HTTPOperation;

@protocol HTTPOperationDelegate <NSObject>

-(void)operationDidComplete:(HTTPOperation*)operation;
-(void)operation:(HTTPOperation*)operation didFailWithError:(NSString*)errorMsg;

@end


@interface HTTPOperation : NSOperationWithState <NSCopying>
{
    NSMutableData* _dataAccumulator;
    NSData* _responseBody;
    NSURLRequest* _request;
    NSURLConnection* _connection;
    NSHTTPURLResponse* _lastResponse;
    NSUInteger _maxResponseSize;
    NSIndexSet* _acceptableStatusCodes;
    NSArray* _acceptableContentTypes;
}

@property (nonatomic, retain) NSMutableData* dataAccumulator;
@property (nonatomic, retain) NSData* responseBody;
@property (nonatomic, retain) NSURLRequest* request;
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, retain) NSHTTPURLResponse* lastResponse;
@property (nonatomic, assign) NSUInteger maxResponseSize;
@property (nonatomic, retain) NSIndexSet* acceptableStatusCodes;
@property (nonatomic, retain) NSArray* acceptableContentTypes;
@property (nonatomic, retain) id<HTTPOperationDelegate> delegate;

+(NSIndexSet*)defaultAcceptableStatusCodes;

-(id)initWithRequest:(NSURLRequest*)request;
-(id)copyWithZone:(NSZone*)zone;

-(void)connection:(NSURLConnection*)conn didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection*)conn didReceiveResponse:(NSURLResponse *)response;
-(void)connection:(NSError*)conn didFailWithError:(NSError*)error;

-(BOOL)isResponseCodeAcceptable;
-(BOOL)isContentTypeAcceptable;

@end

