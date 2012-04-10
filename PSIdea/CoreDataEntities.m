//
//  CoreDataEntities.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/10/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "CoreDataEntities.h"

@implementation CoreDataEntities

+(NSDictionary*)primaryKeys
{
    NSDictionary* dict;
    NSArray* objects = [NSArray arrayWithObjects:@"idString", @"twitterHandle", @"url", nil];
    NSArray* keys = [NSArray arrayWithObjects:@"POI", @"User", @"Photo", nil];
    dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    return dict;
}

@end
