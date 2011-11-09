//
//  CoreDataCreator.m
//  PSIdea
//
//  Created by William Patty on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreDataCreator.h"
#import "User.h"
#import "Event.h"
#import "Photo.h"
@implementation CoreDataCreator

-(id) init{
    self = [super init];
    if(self){
        //Added this comment to test changes
        
    }
    
    return self;
}

-(void) createCoreDataIn:(NSManagedObjectContext*) context{
    
    //Parses SampleData.plist created for app
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    //Gets Path of plist file
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingFormat:@"SampleData.plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        plistPath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    }
    
    //creates Data from plist file
    NSData *plistData = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    
    //creates dictionary from plist data
    NSDictionary *temp = (NSDictionary*)[NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    //TO DO: Need to implement core data parsing and set up.
    
    NSDictionary *root = [temp objectForKey:@"Root"];
    NSArray *users = [root objectForKey:@"Users"];
    NSDictionary *user = nil;
    for (int i=0; i<users.count; i++){
        user = [users objectAtIndex:i];
        [User createUserWithID:[user objectForKey:@"id"] andName:[user objectForKey:@"name"] andLatitude:[user objectForKey:@"latitude"] andLongitude:[user objectForKey:@"longitude"] andEvents:[user objectForKey:@"events"] andFriends:[user objectForKey:@"friends"] andPhoto:[user objectForKey:@"photo"] inManagedObjectContext:context];
     
    }
    
    NSArray *events = [root objectForKey:@"Events"];
    NSDictionary *event = nil;
    
    for(int i=0; i<events.count; i++){
        event = [events objectAtIndex:i];
        
        [Event createEventWithID:[event objectForKey:@"id"] andTitle:[event objectForKey:@"title"] andDetails:[event objectForKey:@"details"] andLatitude:[event objectForKey:@"latitude"] andLongitude:[event objectForKey:@"longitude"] andPhoto:[event objectForKey:@"photo"] andPublic:[event objectForKey:@"public"] andRating:[event objectForKey:@"rating"] andCreator:[event objectForKey:@"creator"] inManagedObjectContext:context];
    }
    
    
}
@end
