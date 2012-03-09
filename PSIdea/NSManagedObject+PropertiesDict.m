//
//  NSManagedObject+PropertiesDict.m
//  PSIdea
//
//  Created by Andrew Stahlman on 2/21/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NSManagedObject+PropertiesDict.h"
#import "CoreDataManager.h"

@implementation NSManagedObject (PropertiesDict)

-(NSDictionary*)propertiesDict
{
    NSDictionary* attributes = [[self entity] attributesByName];
    NSDictionary* properties = [self dictionaryWithValuesForKeys:[attributes allKeys]];

    return properties;
}

-(NSDictionary*)relationshipDict
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    NSDictionary* relationships = [[self entity] relationshipsByName];
    for (id key in relationships)
    {
        NSEntityDescription* targetEntity = [[self valueForKey:key] destinationEntity];
        if ([[relationships valueForKey:key] isKindOfEntity:targetEntity])
        {
            NSManagedObject* obj = [relationships valueForKey:key];
            NSString* objPK = [[CoreDataManager primaryKeys] objectForKey:[obj.class description]];
            [result setValue:[relationships valueForKey:key] forKey:objPK];
        }
        else
        {
            // must be enumerable
        }
    }
    return (NSDictionary*)result;
}

@end
