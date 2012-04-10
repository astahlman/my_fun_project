//
//  HTTPSynchPostOperationWithParse.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/13/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPSynchOperation.h"
#import "SBJson.h"

@interface HTTPSynchPostOperationWithParse : HTTPSynchOperation <NSCopying>
{
    SBJsonParser* _jsonParser;
    SBJsonWriter* _jsonWriter;
    NSManagedObject* _postEntity;
}

@property (nonatomic, retain) SBJsonParser* jsonParser;
@property (nonatomic, retain) SBJsonWriter* jsonWriter;
@property (nonatomic, retain) NSManagedObject* postEntity;

-(id)initWithRequest:(NSURLRequest*)request postEntity:(NSManagedObject*)entity;
-(id)copyWithZone:(NSZone*)zone;

-(void)finishPostOperation;

@end
