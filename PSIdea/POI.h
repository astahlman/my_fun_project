//
//  POI.h
//  PSIdea
//
//  Created by William Patty on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, User;

@interface POI : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * public;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) User *creator;
@property (nonatomic, retain) Photo *photo;


+(POI*) createPOIWithID: (NSNumber*) idNumber andTitle:(NSString*)title andDetails:(NSString*) details andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPhoto:(NSNumber*)photo andRating:(NSNumber*) rating andCreator:(NSString*)creator inManagedObjectContext:(NSManagedObjectContext*) context;
-(NSDictionary*)propertiesDict;
@end
