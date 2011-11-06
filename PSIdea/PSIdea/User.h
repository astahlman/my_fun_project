//
//  User.h
//  PSIdea
//
//  Created by William Patty on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Photo, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSSet *event;
@property (nonatomic, retain) NSSet *friend;
@property (nonatomic, retain) Photo *photo;

+(User*) createUserWithID: (NSNumber*)idNumber andName: (NSString*) name andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andEvents: (NSArray*) event andFriends: (NSArray*) friends andPhoto: (NSNumber*) photoID inManagedObjectContext: (NSManagedObjectContext*) context;

@end

@interface User (CoreDataGeneratedAccessors)


- (void)addEventObject:(Event *)value;
- (void)removeEventObject:(Event *)value;
- (void)addEvent:(NSSet *)values;
- (void)removeEvent:(NSSet *)values;

- (void)addFriendObject:(User *)value;
- (void)removeFriendObject:(User *)value;
- (void)addFriend:(NSSet *)values;
- (void)removeFriend:(NSSet *)values;

@end
