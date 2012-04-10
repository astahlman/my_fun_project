//
//  HTTPSynchGetOperationWithParse.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/13/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPSynchGetOperationWithParse.h"
#import "CoreDataManager.h"
#import "Logging.h"

@implementation HTTPSynchGetOperationWithParse

@synthesize jsonParser = _jsonParser;
@synthesize jsonWriter = _jsonWriter;
@synthesize parsedResults = _parsedResults;
@synthesize relationships = _relationships;
@synthesize managedObjectContext = _managedObjectContext;

-(id)initWithRequest:(NSURLRequest*)request managedObjectContext:(NSManagedObjectContext*)moc;
{
    self = [super initWithRequest:request];
    _jsonWriter = [[SBJsonWriter alloc] init];
    _jsonParser = [[SBJsonParser alloc] init];
    _parsedResults = [[NSMutableArray alloc] init];
    _relationships = [[NSMutableDictionary alloc] init];
    _managedObjectContext = moc;
    return self;
}

-(id)copyWithZone:(NSZone*)zone
{
    HTTPSynchGetOperationWithParse* clone = [super copyWithZone:zone];
    [clone setJsonParser:_jsonParser];
    [clone setJsonWriter:_jsonWriter];
    [clone setParsedResults:_parsedResults];
    [clone setRelationships:_relationships];
    //[clone setDelegate:[self delegate]];
    return clone;
}

-(void)main
{
    if (_operationState != OperationStateCancelled)
    {
        _responseBody = [self executeRequest:_request];
        [[Logging logger] logMessage:[[NSString alloc] initWithData:_responseBody encoding:NSUTF8StringEncoding]];
        if ([self parseResponse:_responseBody])
        {
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            _operationState = OperationStateSuccess;
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
        }
        else
        {
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            _operationState = OperationStateFailed;
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
        }
    }
}

-(BOOL)parseResponse:(NSData*)rawData
{
    NSError* parseError;
    NSArray* arrayToParse;
    
    id jsonDict = [_jsonParser objectWithString:[[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding] error:&parseError];
    if (parseError != nil)
    {
        [[Logging logger] logMessage:parseError.description];
        return NO;
    }
    else
    {
        if ([jsonDict isKindOfClass:[NSDictionary class]])
        {
            arrayToParse = [NSArray arrayWithObject:jsonDict];
        }
        else
        {
            arrayToParse = jsonDict;
        }
        NSMutableArray* results = [[NSMutableArray alloc] init];
        for (NSDictionary* dict in arrayToParse)
        {
            //NSManagedObject* resultObj = [self parseDictionaryToResults:dict];
            NSManagedObject* resultObj = [CoreDataManager parseManagedObject:dict managedObjectContext:_managedObjectContext];
            if (resultObj != nil)
            {
                [results addObject:resultObj]; 
            }
            else
            {
                return NO;
            }
        }
        
        _parsedResults = [NSArray arrayWithArray:results];
    }
    
    return YES;
}

/*
-(NSManagedObject*)parseDictionaryToResults:(NSDictionary*)dict
{
    NSString* poiPK = [[CoreDataManager primaryKeys] valueForKey:@"POI"];
    NSString* userPK = [[CoreDataManager primaryKeys] valueForKey:@"User"];
    NSString* photoPK = [[CoreDataManager primaryKeys] valueForKey:@"Photo"];
    NSManagedObject* result;
    if ([dict valueForKey:poiPK] != nil)
    {
        POI* poi = [[POI alloc] init];
        for (NSString* key in dict)
        {
            // set all of the non-relationship properties
            if ([[[poi entity] relationshipsByName] valueForKey:key] == nil)
            {
                [poi setValue:[dict valueForKey:key] forKey:key];
            }
            else
            {
                // relationship objects are identified only by their primary key
                // add these to the relationships dict
                NSString* handle = [dict valueForKey:key];
                [_relationships setObject:handle forKey:@"creator"];
            }
        }
        result = poi;
    }
    else if ([dict valueForKey:userPK] != nil)
    {
        User* user = [[User alloc] init];
        
        // set the primary key
        [user setValue:[dict valueForKey:@"twitterHandle"] forKey:@"twitterHandle"];
        
        // set the POIs
        NSArray* idStrings = [dict valueForKey:@"pois"];
        NSMutableArray* idNums = [[NSMutableArray alloc] init];
        NSNumberFormatter* numFormatter = [[NSNumberFormatter alloc] init];
        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        for (NSString* numString in idStrings)
        {
            NSNumber* idNum = [numFormatter numberFromString:numString];
            [idNums addObject:idNum];
        }
        
        [_relationships setObject:idNums forKey:@"pois"];
        result = user;
    }
    else if ([dict valueForKey:photoPK] != nil)
    {
        // TODO: start downloading the pk from the specified url
        Photo* p = [[Photo alloc] init];
        p.url = [NSURL URLWithString:[dict valueForKey:@"url"]];
        NSNumberFormatter* numFormatter = [[NSNumberFormatter alloc] init];
        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber* idNum = [numFormatter numberFromString:[dict valueForKey:@"poi"]];
        [_relationships setObject:idNum forKey:@"poi"];
        result = p;
    }
    else 
    {
        [self failWithError:OperationErrorJSONParsingError];
    }
    
    return result;
}
*/

-(NSString*)messageForError:(OperationError)error
{
    NSString* message = [super messageForError:error];
    if (error == OperationErrorJSONParsingError)
    {
        message = @"Failed to parse JSON.";
    }
    return message;
}

-(void)failWithError:(OperationError)error
{
    [[Logging logger] logMessage:[self messageForError:error]];
    [super failWithError:error];
}

@end
