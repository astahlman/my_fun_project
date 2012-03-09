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
+(POI*)parsePOI:(NSDictionary*)poiDict;
+(User*)parseUser:(NSDictionary*)userDict;

@end
