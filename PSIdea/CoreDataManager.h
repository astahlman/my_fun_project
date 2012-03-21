//
//  CoreDataManager.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/28/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataEntities.h"

@interface CoreDataManager : NSObject

+(NSMutableArray*) fetchEntity:(NSString*)entityName fromContext:(NSManagedObjectContext*)context withPredicate:(NSPredicate*)predicate withSortKey:(NSString*)sortKey ascending:(BOOL)isAscending;
+(NSDictionary*)primaryKeys;
+(NSManagedObject*)parseManagedObject:(NSDictionary*)objDict managedObjectContext:(NSManagedObjectContext*)moc;
+(POI*)parsePOI:(NSDictionary*)poiDict managedObjectContext:(NSManagedObjectContext*)moc;
+(User*)parseUser:(NSDictionary*)userDict managedObjectContext:(NSManagedObjectContext*)moc;
+(Photo*)parsePhoto:(NSDictionary*)photoDict managedObjectContext:(NSManagedObjectContext*)moc;

@end
