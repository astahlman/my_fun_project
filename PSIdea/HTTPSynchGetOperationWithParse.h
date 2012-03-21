//
//  HTTPSynchGetOperationWithParse.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/13/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPSynchOperation.h"
#import "SBJson.h"

@interface HTTPSynchGetOperationWithParse : HTTPSynchOperation <NSCopying>
{
    SBJsonParser* _jsonParser;
    SBJsonWriter* _jsonWriter;
    NSMutableArray* _parsedResults;
    NSMutableDictionary* _relationships;
    NSManagedObjectContext* _managedObjectContext;
}

@property (nonatomic, retain) SBJsonParser* jsonParser;
@property (nonatomic, retain) SBJsonWriter* jsonWriter;
@property (nonatomic, retain) NSMutableArray* parsedResults;
@property (nonatomic, retain) NSMutableDictionary* relationships;
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

//@property (nonatomic, retain) id<HTTPGetOperationWithParseDelegate> delegate;

-(id)initWithRequest:(NSURLRequest*)request managedObjectContext:(NSManagedObjectContext*)moc;
-(id)copyWithZone:(NSZone*)zone;

-(NSManagedObject*)parseDictionaryToResults:(NSDictionary*)dict;
-(NSString*)messageForError:(OperationError)error;
-(void)failWithError:(OperationError)error;
-(BOOL)parseResponse:(NSData*)rawData;

@end
