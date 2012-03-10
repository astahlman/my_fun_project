//
//  POI.m
//  PSIdea
//
//  Created by William Patty on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "POI.h"
#import "Photo.h"
#import "User.h"
#import "NSManagedObject+PropertiesDict.h"

@implementation POI

@dynamic creationDate;
@dynamic details;
@dynamic idNumber;
@dynamic latitude;
@dynamic longitude;
@dynamic public;
@dynamic rating;
@dynamic title;
@dynamic creator;
@dynamic photo;

+(POI*) createPOIWithID: (NSNumber*) idNumber andTitle:(NSString*)title andDetails:(NSString*) details andLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andPhoto:(NSNumber*)photo andRating:(NSNumber*) rating andCreator:(NSString*)creator inManagedObjectContext:(NSManagedObjectContext*) context{
    
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
        NSDate *date = [NSDate date];
        poi.creationDate = date;
        //TO DO: set up photo
        //Don't forget to remove!!!!!!        

        
        User *user = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        request.predicate = [NSPredicate predicateWithFormat:@"twitterHandle = %@", creator];
        
        NSError *error = nil;
        
        user = [[context executeFetchRequest:request error:&error] lastObject];
        if(!error && !user){
            user = [User createUserWithHandle:creator andPOIs:nil inManagedObjectContext:context];
        }
        
        poi.creator = user;
        
    }
    else if(!error && poi){
        if(poi.title==nil){
            poi.title = title;
            poi.details = details;
            poi.latitude = latitude;
            poi.longitude = longitude;
            
            //TO DO: set up photo
            User *user = nil;
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            
            request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
            request.predicate = [NSPredicate predicateWithFormat:@"twitterHandle = %@", creator];
            
            NSError *error = nil;
            
            user = [[context executeFetchRequest:request error:&error] lastObject];
            if(!error && !user){
                user = [User createUserWithHandle:creator andPOIs:nil inManagedObjectContext:context];
            }
            poi.creator = user;
        }
        
        
    }    
        
    return poi;
}


-(NSDictionary*)propertiesDict
{
    NSMutableDictionary* dict = [super propertiesDict];
    
    NSDictionary* listDict = [dict objectForKey:@"lists"];
    [dict removeObjectForKey:@"lists"];
    NSSet* listIds = [listDict objectForKey:@"idNumber"];
    NSSet* listNames = [listDict objectForKey:@"title"];
    NSArray* idNums = [listIds allObjects];
    NSArray* titles = [listNames allObjects];
    NSDictionary* idDict = [NSDictionary dictionaryWithObjects:idNums forKeys:titles];
    [dict setObject:idDict forKey:@"lists"];
    
    NSDictionary* resultDict = [NSDictionary dictionaryWithDictionary:dict];
    return resultDict;
    
}


@end
