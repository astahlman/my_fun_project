//
//  User.m
//  PSIdea
//
//  Created by William Patty on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "POI.h"
#import "Photo.h"
#import "User.h"


@implementation User

@dynamic idNumber;
@dynamic name;
@dynamic longitude;
@dynamic latitude;
@dynamic poi;
@dynamic friend;
@dynamic photo;

//creates new user managed object (if it doesn't already exist)
+(User*) createUserWithID: (NSNumber*)idNumber andName: (NSString*) name andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPOIs: (NSArray*) pois andFriends: (NSArray*) friends andPhoto: (NSNumber*) photoID inManagedObjectContext: (NSManagedObjectContext*) context
{
    
    User *user = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"idNumber = %@", idNumber];
    
    NSError *error = nil;
    
    user = [[context executeFetchRequest:request error:&error] lastObject];
    
    if(!user && !error){
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.idNumber = idNumber;
        user.name = name;
        user.latitude =latitude;
        user.longitude = longitude;
        //user.photo = call createphoto method
        for(int t=0; t<friends.count; t++){
            [User createUserWithID:[friends objectAtIndex:t] andName:nil andLatitude:nil andLongitude:nil andPOIs:nil andFriends:nil andPhoto:nil inManagedObjectContext:context];
            
        }
        for(int i=0; i<pois.count; i++){
            [POI createPOIWithID:[pois objectAtIndex:i] andTitle:nil andDetails:nil andLatitude:nil andLongitude:nil andPhoto:nil andPublic:nil andRating:nil andCreator:nil andList:nil inManagedObjectContext:context];       
        }
        
    }
    //Need to fill in empty information (This is needed because of way friends are setup in data)
    else if(user &&!error){
        if (user.name == nil) {
            
            user.name = name;
            user.latitude =latitude;
            user.longitude = longitude;
            //user.photo = call createphoto method
            for(int t=0; t<friends.count; t++){
                [User createUserWithID:[friends objectAtIndex:t] andName:nil andLatitude:nil andLongitude:nil andPOIs:nil andFriends:nil andPhoto:nil inManagedObjectContext:context];
                
            }

            for(int i=0; i<pois.count; i++){
            [POI createPOIWithID:[pois objectAtIndex:i] andTitle:nil andDetails:nil andLatitude:nil andLongitude:nil andPhoto:nil andPublic:nil andRating:nil andCreator:nil andList:nil inManagedObjectContext:context];   
            }
            
        }
    }
    
    return user;
}




@end
