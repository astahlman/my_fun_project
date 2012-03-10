//
//  User.h
//  PSIdea
//
//  Created by William Patty on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class POI;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * twitterHandle;
@property (nonatomic, retain) NSSet *pois;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPoisObject:(POI *)value;
- (void)removePoisObject:(POI *)value;
- (void)addPois:(NSSet *)values;
- (void)removePois:(NSSet *)values;
+(User*) createUserWithHandle:(NSString*) twitterHandle andPOIs: (NSArray*) pois inManagedObjectContext:(NSManagedObjectContext*) context;
@end
