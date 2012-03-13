//
//  HTTPSynchOperation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/12/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NSOperationWithState.h"

@interface HTTPSynchOperation : NSOperationWithState <NSCopying>
{
    NSData* _responseBody;
    NSURLRequest* _request;
    NSHTTPURLResponse* _response;
    NSIndexSet* _acceptableStatusCodes;
    NSArray* _acceptableContentTypes;
}

@property (nonatomic, retain) NSData* responseBody;
@property (nonatomic, retain) NSURLRequest* request;
@property (nonatomic, retain) NSHTTPURLResponse* response;
@property (nonatomic, retain) NSIndexSet* acceptableStatusCodes;
@property (nonatomic, retain) NSArray* acceptableContentTypes;
//@property (nonatomic, retain) id<HTTPSynchOperationDelegate> delegate;

+(NSIndexSet*)defaultAcceptableStatusCodes;

-(id)initWithRequest:(NSURLRequest*)request;
-(id)copyWithZone:(NSZone*)zone;

-(void)cancel;
-(BOOL)isExecuting;
-(BOOL)isFinished;
-(BOOL)isConcurrent;

-(NSData*)executeRequest:(NSURLRequest*)request;

@end
