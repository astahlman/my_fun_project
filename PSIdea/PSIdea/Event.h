//
//  Event.h
//  PSIdea
//
//  Created by William Patty on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "POI.h"

@class Photo, User;

@interface Event : POI

// These should already be inherited, right? Check before deleting...
/*
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSNumber * public;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) User *creator;
@property (nonatomic, retain) Photo *photo;
*/



+(Event*) createEventWithID: (NSNumber*) idNumber andTitle:(NSString*)title andDetails:(NSString*) details andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPhoto:(NSNumber*)photo andPublic: (NSNumber*) public andRating:(NSNumber*) rating andCreator:(NSNumber*)creator andStartDate:(NSDate*)start andEndDate:(NSDate*)end andRecurrenceType:(NSString*)recurrence inManagedObjectContext:(NSManagedObjectContext*) context;
@end
