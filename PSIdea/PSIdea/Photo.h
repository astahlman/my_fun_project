//
//  Photo.h
//  PSIdea
//
//  Created by William Patty on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) Event *event;



@end
