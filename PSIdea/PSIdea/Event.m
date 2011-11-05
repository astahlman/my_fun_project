//
//  Event.m
//  PSIdea
//
//  Created by William Patty on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "Photo.h"
#import "User.h"


@implementation Event

@dynamic details;
@dynamic idNumber;
@dynamic public;
@dynamic rating;
@dynamic title;
@dynamic latitude;
@dynamic longitude;
@dynamic creator;
@dynamic photo;

+(Event*) createEventWithID: (NSNumber*) idNumber andTitle:(NSString*)title andDetails:(NSString*) details andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPhoto:(NSNumber*)photo andPublic: (NSNumber*) public andRating:(NSNumber*) rating andCreator:(NSNumber*)creator inManagedObjectContext:(NSManagedObjectContext*) context{
    
    Event *event = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity =[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", idNumber];
    
    NSError *error = nil;
    
    event = [[context executeFetchRequest:request error:&error] lastObject];
    
    if(!error && !event){
        event =[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        event.idNumber = idNumber;
        event.title = title;
        event.details = details;
        event.latitude = latitude;
        event.longitude = longitude;
        event.public =public;
        
        //TO DO: set up event and photo
        
        
    }
    else if(!error && event){
        if(event.title==@"null"){
            event.title = title;
            event.details = details;
            event.latitude = latitude;
            event.longitude = longitude;
            event.public =public;
            
            //TO DO: set up event and photo
        }
        
        
    }
    
    return event;
}



@end
