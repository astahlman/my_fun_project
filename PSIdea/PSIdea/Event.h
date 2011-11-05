//
//  Event.h
//  PSIdea
//
//  Created by William Patty on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, User;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * public;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) User *creator;

@end
