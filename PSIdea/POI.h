//
//  POI.h
//  PSIdea
//
//  Created by William Patty on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, User;

@interface POI : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * idString;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) User *creator;
@property (nonatomic, retain) Photo *photo;


+(POI*) createPOIWithID: (NSString*) idString andTitle:(NSString*)title andDetails:(NSString*) details andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPhoto:(NSNumber*)photo andRating:(NSNumber*) rating andCreator:(NSString*)creator inManagedObjectContext:(NSManagedObjectContext*) context;
@end
