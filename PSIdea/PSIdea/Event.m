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

@synthesize tags;

+(Event*) createEventWithID: (NSNumber*) idNumber andTitle:(NSString*)title andDetails:(NSString*) details andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPhoto:(NSNumber*)photo andPublic: (NSNumber*) public andRating:(NSNumber*) rating andCreator:(NSNumber*)creator inManagedObjectContext:(NSManagedObjectContext*) context{
    
    Event *event = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity =[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"idNumber = %@", idNumber];
    
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
        //TO DO: set up photo
        
        User *user = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        request.predicate = [NSPredicate predicateWithFormat:@"idNumber = %@", creator];
        
        NSError *error = nil;
        
        user = [[context executeFetchRequest:request error:&error] lastObject];
        if(!error && !user){
            user = [User createUserWithID:creator andName:nil andLatitude:nil andLongitude:nil andEvents:nil andFriends:nil andPhoto:nil inManagedObjectContext:context];
        }
        event.creator = user;
        
    }
    else if(!error && event){
        if(event.title==nil){
            event.title = title;
            event.details = details;
            event.latitude = latitude;
            event.longitude = longitude;
            event.public =public;
            
            //TO DO: set up photo
            User *user = nil;
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            
            request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
            request.predicate = [NSPredicate predicateWithFormat:@"idNumber = %@", creator];
            
            NSError *error = nil;
            
            user = [[context executeFetchRequest:request error:&error] lastObject];
            if(!error && !user){
                user = [User createUserWithID:creator andName:nil andLatitude:nil andLongitude:nil andEvents:nil andFriends:nil andPhoto:nil inManagedObjectContext:context];
            }
            event.creator = user;
        }
        
        
    }    
    
    [event.tags addObjectsFromArray:[Event extractTags:event.details]];
    
    return event;
}

/* Extracts tags delimited by the '#' and space characters
 from a string of text.
 */
+(NSMutableArray*)extractTags:(NSString*) text {
    NSMutableArray* tagArray = [[NSMutableArray alloc] init];
    int length = [text length];
    for (int i = 0; i < length; i++) {
        if ([text characterAtIndex:i] == '#') {
            i += 1;
            int start = i;
            while (i < length && [text characterAtIndex:i] != ' ') {
                i++;
            }
            int tagLength = i - start;
            NSRange range = NSMakeRange(start, tagLength);
            NSString* tag = [NSString stringWithString:[text substringWithRange:range]];
            [tagArray addObject:tag];
        }
    }
    
    return tagArray;
}




@end
