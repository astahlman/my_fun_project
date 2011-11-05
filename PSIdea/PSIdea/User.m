//
//  User.m
//  PSIdea
//
//  Created by William Patty on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "Event.h"
#import "Photo.h"
#import "User.h"


@implementation User

@dynamic idNumber;
@dynamic location;
@dynamic name;
@dynamic event;
@dynamic friend;
@dynamic photo;

//creates new user managed object (if it doesn't already exist)
+(User*) createUserWithID: (NSNumber*)idNumber andName: (NSString*) name andLocation: (NSString*) location andEvents: (NSArray*) event andFriends: (NSArray*) friends andPhoto: (NSNumber*) photoID inManagedObjectContext: (NSManagedObjectContext*) context{
    
    User *user = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", idNumber];
    
    NSError *error = nil;
    
    user = [[context executeFetchRequest:request error:&error] lastObject];
    
    if(!user && !error){
        user = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        user.idNumber = idNumber;
        user.name = name;
        user.location =location;
        //user.photo = call createphoto method
        
        for(int i=0; i<event.count; i++){
            //here call event creation
        }
    
    }
    //Need to fill in empty information (This is needed because of way friends are setup in data)
    else if(user &&!error){
        if (user.name == @"null") {
            
            user.name = name;
            user.location =location;
            //user.photo = call createphoto method
            
            for(int i=0; i<event.count; i++){
                //here call event creation
            }
            
        }
    }
    
    return user;
}

@end
