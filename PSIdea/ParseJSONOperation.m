//
//  ParseJSONOperation.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/7/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "ParseJSONOperation.h"
#import "CoreDataEntities.h"
#import "CoreDataManager.h"

@implementation ParseJSONOperation

-(NSArray*)parseData
{
    NSMutableArray* results;
    NSError* parserError = nil;
    NSString* dataString = [[NSString alloc] initWithData:_rawData encoding:NSUTF8StringEncoding];
    NSArray* jsonEntities = [_jsonParser objectWithString:dataString error:&parserError];
    
    if (parserError != nil)
    {
        [[Logging logger] logMessage:parserError.description];
        [self failWithError:OperationErrorJSONParsingError];
    }
    else 
    {
        results = [[NSMutableArray alloc] init];
        for (NSDictionary* obj in jsonEntities)
        {
            NSString* poiTitle = [obj objectForKey:@"title"];
            NSString* twitterHandle = [obj objectForKey:@"twitterHandle"];
            
            // POI
            if (poiTitle != nil)
            {
                [results addObject:[CoreDataManager parsePOI:obj]];
            }
            // User
            else if (twitterHandle != nil)
            {
                [results addObject:[CoreDataManager parseUser:obj]];
            }
        }
    }
    return results;
}

-(NSString*)messageForError:(OperationError)error
{
    NSString* message;
    switch (error) {
        case OperationErrorJSONParsingError:
            message = @"Failed to parse JSON.";
            break;
        default:
            assert(NO);
    }
    return message;
}

-(void)failWithError:(OperationError)error
{
    [[Logging logger] logMessage:[self messageForError:error]];
    [super failWithError:error];
}
@end
