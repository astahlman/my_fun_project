//
//  POI.h
//  PSIdea
//
//  Created by William Patty on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List, Photo, User;

@interface POI : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * public;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) User *creator;
@property (nonatomic, retain) NSSet *lists;
@property (nonatomic, retain) Photo *photo;


+(NSString*)extractTags:(NSString*) text;
+(POI*) createPOIWithID: (NSNumber*) idNumber andTitle:(NSString*)title andDetails:(NSString*) details andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPhoto:(NSNumber*)photo andPublic: (NSNumber*) public andRating:(NSNumber*) rating andCreator:(NSNumber*)creator andLists:(NSArray*) listNumbers inManagedObjectContext:(NSManagedObjectContext*) context;

@end
