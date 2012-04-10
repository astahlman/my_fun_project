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

-(NSDictionary*)relationshipsDict
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    NSDictionary* relationships = [[self entity] relationshipsByName];
    for (id key in relationships)
    {
        if ([self valueForKey:key] != nil)
        {
            NSEntityDescription* targetEntity = [[relationships valueForKey:key] destinationEntity];
            NSString* actualClass = NSStringFromClass([[self valueForKey:key] class]);
            NSString* targetClass = targetEntity.managedObjectClassName;
            if ([actualClass isEqualToString:targetClass])
            {
                NSManagedObject* obj = [self valueForKey:key];
                NSString* keyPath = [[CoreDataManager primaryKeys] objectForKey:targetEntity.managedObjectClassName];
                [result setValue:[obj valueForKey:keyPath] forKey:key];
            }
            else
            {
                // must be enumerable
                NSMutableArray* pkArray = [[NSMutableArray alloc] init];
                NSEnumerator* enumerator = [[self valueForKey:key] objectEnumerator];
                for (id entity in enumerator)
                {
                    NSString* keyPath = [[CoreDataManager primaryKeys] objectForKey:targetEntity.managedObjectClassName];
                    [pkArray addObject:[entity valueForKey:keyPath]];
                }
                [result setValue:pkArray forKey:key];
            }
        }
    }
    
    return (NSDictionary*)result;
}

@end
