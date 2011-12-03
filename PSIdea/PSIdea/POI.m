
//  POI.m
//  PSIdea
//
//  Created by William Patty on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "POI.h"
#import "Photo.h"
#import "User.h"


@implementation POI

@dynamic details;
@dynamic idNumber;
@dynamic latitude;
@dynamic longitude;
@dynamic public;
@dynamic rating;
@dynamic title;
@dynamic tags;
@dynamic creationDate;
@dynamic creator;
@dynamic photo;


+(POI*) createPOIWithID: (NSNumber*) idNumber andTitle:(NSString*)title andDetails:(NSString*) details andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPhoto:(NSNumber*)photo andPublic: (NSNumber*) public andRating:(NSNumber*) rating andCreator:(NSNumber*)creator inManagedObjectContext:(NSManagedObjectContext*) context{
    
    POI *poi = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity =[NSEntityDescription entityForName:@"POI" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"idNumber = %@", idNumber];
    
    NSError *error = nil;
    
    poi = [[context executeFetchRequest:request error:&error] lastObject];
    
    if(!error && !poi){
        poi =[NSEntityDescription insertNewObjectForEntityForName:@"POI" inManagedObjectContext:context];
        poi.idNumber = idNumber;
        poi.title = title;
        poi.details = details;
        poi.latitude = latitude;
        poi.longitude = longitude;
        poi.public =public;
        //TO DO: set up photo
        
        User *user = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        request.predicate = [NSPredicate predicateWithFormat:@"idNumber = %@", creator];
        
        NSError *error = nil;
        
        user = [[context executeFetchRequest:request error:&error] lastObject];
        if(!error && !user){
            user = [User createUserWithID:creator andName:nil andLatitude:nil andLongitude:nil andPOIs:nil andFriends:nil andPhoto:nil inManagedObjectContext:context];
        }
        poi.creator = user;
        
    }
    else if(!error && poi){
        if(poi.title==nil){
            poi.title = title;
            poi.details = details;
            poi.latitude = latitude;
            poi.longitude = longitude;
            poi.public =public;
            
            //TO DO: set up photo
            User *user = nil;
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            
            request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
            request.predicate = [NSPredicate predicateWithFormat:@"idNumber = %@", creator];
            
            NSError *error = nil;
            
            user = [[context executeFetchRequest:request error:&error] lastObject];
            if(!error && !user){
                user = [User createUserWithID:creator andName:nil andLatitude:nil andLongitude:nil andPOIs:nil andFriends:nil andPhoto:nil inManagedObjectContext:context];
            }
            poi.creator = user;
        }
        
        
    }    
    
    poi.tags = [POI extractTags:details];
    
    return poi;
}

/* Extracts tags delimited by the '#' and space characters
 from a string of text.
 */
+(NSString*)extractTags:(NSString*) text {
    NSMutableString* tagString = [[NSMutableString alloc] init];
    int length = [text length];
    for (int i = 0; i < length; i++) {
        if ([text characterAtIndex:i] == '#') {
            while (i < length && [text characterAtIndex:i] != ' ') {
                [tagString appendString:[text substringWithRange:NSMakeRange(i, 1)]];
                i++;
            }
        }
    }
    NSString* tags = [NSString stringWithString:tagString];
    return tags;
}
@end
