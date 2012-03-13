//
//  HTTPOperationWithParse.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/10/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPOperation.h"
#import "SBJson.h"
#import "Networking.h"

@class HTTPGetOperationWithParse;

@protocol HTTPGetOperationWithParseDelegate <HTTPOperationDelegate>

-(void)operation:(HTTPGetOperationWithParse*)operation didParseResults:(NSArray*)entitites;

@end

@interface HTTPGetOperationWithParse : HTTPOperation <NSCopying>
{
    SBJsonParser* _jsonParser;
    SBJsonWriter* _jsonWriter;
    NSArray* _parsedResults;
    NSManagedObjectContext* _managedObjectContext;
}
@property (nonatomic, retain) SBJsonParser* jsonParser;
@property (nonatomic, retain) SBJsonWriter* jsonWriter;
@property (nonatomic, retain) NSArray* parsedResults;
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) id<HTTPGetOperationWithParseDelegate> delegate;

-(id)initWithRequest:(NSURLRequest*)request managedObjectContext:(NSManagedObjectContext*)moc;
-(id)copyWithZone:(NSZone*)zone;
-(void)connectionDidFinishLoading:(NSConnection*)connection;
-(BOOL)parseResponse;

@end
