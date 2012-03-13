//
//  HTTPOperationWithParse.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/10/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPGetOperationWithParse.h"
#import "CoreDataManager.h"

@interface HTTPGetOperationWithParse() 

-(NSManagedObject*)parseDictionaryToResults:(NSDictionary*)dict;

@end

@implementation HTTPGetOperationWithParse

@synthesize jsonParser = _jsonParser;
@synthesize jsonWriter = _jsonWriter;
@synthesize parsedResults = _parsedResults;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize delegate;

-(id)initWithRequest:(NSURLRequest*)request managedObjectContext:(NSManagedObjectContext*)moc
{
    self = [super initWithRequest:request];
    _managedObjectContext = moc;
    return self;
}

-(id)copyWithZone:(NSZone*)zone
{
    HTTPGetOperationWithParse* clone = [super copyWithZone:zone];
    [clone setJsonParser:_jsonParser];
    [clone setJsonWriter:_jsonWriter];
    [clone setDelegate:[self delegate]];
    return clone;
}

-(void)connectionDidFinishLoading:(NSConnection*)connection
{
    _responseBody = _dataAccumulator;
    _dataAccumulator = nil;
    
    // Because we fill out _dataAccumulator lazily, an empty body will leave _dataAccumulator 
    // set to nil.  That's not what our clients expect, so we fix it here.
    
    if (_responseBody == nil) {
        _responseBody = [[NSData alloc] init];
    }

    if (!self.isResponseCodeAcceptable) 
    {
        [self failWithError:OperationErrorBadResponseCode];
    } 
    else if (!self.isContentTypeAcceptable) 
    {
        [self failWithError:OperationErrorBadContentType];
    }
    else
    {
        if ([self parseResponse])
        {
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            _operationState = OperationStateSuccess;
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
        }
        else 
        {
            [self failWithError:OperationErrorJSONParsingError];
        }
    }
}

-(BOOL)parseResponse
{
    NSError* parseError;
    NSArray* arrayToParse;
    
    id parseResult = [_jsonParser objectWithString:[[NSString alloc] initWithData:_responseBody encoding:NSUTF8StringEncoding] error:&parseError];
    if (parseError != nil)
    {
        [[Logging logger] logMessage:parseError.description];
        return NO;
    }
    else
    {
        if ([parseResult isKindOfClass:[NSDictionary class]])
        {
            arrayToParse = [NSArray arrayWithObject:parseResult];
        }
        else
        {
            arrayToParse = parseResult;
        }
        NSMutableArray* results = [[NSMutableArray alloc] init];
        for (NSDictionary* dict in arrayToParse)
        {
            NSManagedObject* resultObj = [self parseDictionaryToResults:dict];
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
                NSString* handle = [dict valueForKey:key];
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"twitterHandle MATCHES %@", handle]; 
                NSMutableArray* fetchResults = [CoreDataManager fetchEntity:@"User" fromContext:_managedObjectContext withPredicate:predicate withSortKey:nil ascending:YES];
                
                // we should never get more than one user with the same twitterHandle
                assert([fetchResults count] <= 1);
                User* theCreator;
                if ([fetchResults count] == 1)
                {
                    theCreator = [fetchResults objectAtIndex:1];
                }
                else
                {
                    theCreator = [User createUserWithHandle:handle andPOIs:nil inManagedObjectContext:_managedObjectContext];
                    // TODO: should we request the User from the network, too?
                }
                poi.creator = theCreator;
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

        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"idNumber IN %@", idNums]; 
        NSMutableArray* fetchResults = [CoreDataManager fetchEntity:@"POI" fromContext:_managedObjectContext withPredicate:predicate withSortKey:@"creationDate" ascending:YES];
        NSSet* thePOIs = [NSSet setWithArray:fetchResults];
        user.pois = thePOIs;
        result = user;
    }
    else if ([dict valueForKey:photoPK] != nil)
    {
        // TODO: start downloading the pk from the specified url
        Photo* p = [[Photo alloc] init];
        p.url = [NSURL URLWithString:[dict valueForKey:@"url"]];
        result = p;
    }
    else 
    {
        [self failWithError:OperationErrorJSONParsingError];
    }
    
    return result;
}

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
