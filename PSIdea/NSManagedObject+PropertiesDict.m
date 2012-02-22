//
//  NSManagedObject+PropertiesDict.m
//  PSIdea
//
//  Created by Andrew Stahlman on 2/21/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NSManagedObject+PropertiesDict.h"

@implementation NSManagedObject (PropertiesDict)

-(NSMutableDictionary*)propertiesDict
{
    NSDictionary* attributes = [[self entity] attributesByName];
    NSDictionary* properties = [self dictionaryWithValuesForKeys:[attributes allKeys]];
    NSMutableDictionary* allProps = [NSMutableDictionary dictionaryWithDictionary:properties];
    NSDictionary* relationships = [[self entity] relationshipsByName];
    for (id key in relationships)
    {
        id relationship = [relationships objectForKey:key];
        NSEntityDescription* destEntity = [relationship destinationEntity];
        NSDictionary* relationshipAttributes = [destEntity attributesByName];
        id relationshipObject = [self valueForKey:key];
        NSDictionary* relationshipProps = [relationshipObject dictionaryWithValuesForKeys:[relationshipAttributes allKeys]];
        if (relationshipProps == nil)
        {
            relationshipProps = [[NSDictionary alloc] init];
        }
        //NSString* keyString = key;
        //NSString* realString = [NSString stringWithString:keyString];
        [allProps setObject:relationshipProps forKey:key];
    }
    return allProps;
}

@end
