//
//  User.h
//  PSIdea
//
//  Created by William Patty on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Photo, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) NSSet *friend;
@property (nonatomic, retain) NSSet *event;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFriendObject:(User *)value;
- (void)removeFriendObject:(User *)value;
- (void)addFriend:(NSSet *)values;
- (void)removeFriend:(NSSet *)values;

- (void)addEventObject:(Event *)value;
- (void)removeEventObject:(Event *)value;
- (void)addEvent:(NSSet *)values;
- (void)removeEvent:(NSSet *)values;

@end
