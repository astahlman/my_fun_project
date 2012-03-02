//
//  List.h
//  PSIdea
//
//  Created by William Patty on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class POI;

@interface List : NSManagedObject

@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *pois;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)addPoisObject:(POI *)value;
- (void)removePoisObject:(POI *)value;
- (void)addPois:(NSSet *)values;
- (void)removePois:(NSSet *)values;

+(List*) createDefaultListWithTitle:(NSString*)title InManagedObjectContext:(NSManagedObjectContext*)context;
+(List*) getDefaulListInMangedObjectContext:(NSManagedObjectContext*) context;
+(List*) createtListWithTitle:(NSString*)title withIDNumber: (NSNumber*) idNumber InManagedObjectContext:(NSManagedObjectContext*)context;
@end
