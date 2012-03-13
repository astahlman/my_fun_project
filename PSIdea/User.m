//
//  User.m
//  PSIdea
//
//  Created by William Patty on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "POI.h"


@implementation User

@dynamic twitterHandle;
@dynamic pois;


//creates new user managed object (if it doesn't already exist)
+(User*) createUserWithHandle:(NSString*) twitterHandle andPOIs: (NSArray*) pois inManagedObjectContext:(NSManagedObjectContext*) context
{

    User *user = nil;
    // TODO: We'll eventually want to disallow POI's without a creator
    // For now we can allow it for testing purposes
    if (twitterHandle == nil)
    {
        twitterHandle = @"Default PSI Tester";
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"twitterHandle = %@", twitterHandle];

    NSError *error = nil;

    user = [[context executeFetchRequest:request error:&error] lastObject];

    if(!user && !error){
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.twitterHandle = twitterHandle;  
        // TODO: You can't create POI's without a creator, so you can't assign existing POI's
        // to a new creator. Eliminate the andPOIs: argument.
        for(int i=0; i<pois.count; i++)
        {
            [POI createPOIWithID:[pois objectAtIndex:i] andTitle:nil andDetails:nil andLatitude:nil andLongitude:nil andPhoto:nil  andRating:nil andCreator:twitterHandle inManagedObjectContext:context];       
        }
    
    }

    return user;
}

@end
