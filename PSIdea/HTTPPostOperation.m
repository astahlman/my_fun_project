//
//  HTTPPostOperation.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/11/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPPostOperation.h"

@implementation HTTPPostOperation

@synthesize postEntity = _postEntity;
@synthesize delegate;

-(id)initWithRequest:(NSURLRequest*)request postEntity:(NSManagedObject*)entity
{
    self = [super initWithRequest:request];
    _postEntity = entity;
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    HTTPPostOperation* clone = [super copyWithZone:zone];
    [clone setPostEntity:_postEntity];
    [clone setDelegate:[self delegate]];
    return clone;
}
@end
