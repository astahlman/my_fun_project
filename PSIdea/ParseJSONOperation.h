//
//  ParseJSONOperation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/7/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Networking.h"
#import "SBJson.h"

@interface ParseJSONOperation : NSOperationWithState
{
    NSData* _rawData;
    SBJsonParser* _jsonParser;
    SBJsonWriter* _jsonWriter;
}


@end
