//
//  HTTPOperation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/6/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Networking.h"


@interface HTTPOperation : NSOperationWithState
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

+(NSIndexSet*)defaultAcceptableStatusCodes;

-(id)initWithRequest:(NSURLRequest*)request;

-(void)connection:(NSURLConnection*)conn didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection*)conn didReceiveResponse:(NSURLResponse *)response;
-(void)connection:(NSError*)conn didFailWithError:(NSError*)error;



@end

