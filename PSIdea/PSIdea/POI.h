//
//  POI.h
//  PSIdea
//
//  Created by William Patty on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, User;

@interface POI : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
//TODO: public is a reserved word, shouldn't be a variable name. 
@property (nonatomic, retain) NSNumber * public; 
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * title;
//TODO: Revisit whether this should be an array (better to store, but can't query)
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) User *creator;
@property (nonatomic, retain) Photo *photo;



+(NSString*)extractTags:(NSString*) text;

+(POI*) createPOIWithID: (NSNumber*) idNumber andTitle:(NSString*)title andDetails:(NSString*) details andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPhoto:(NSNumber*)photo andPublic: (NSNumber*) public andRating:(NSNumber*) rating andCreator:(NSNumber*)creator inManagedObjectContext:(NSManagedObjectContext*) context;
@end
