//
//  CoreDataCreator.m
//  PSIdea
//
//  Created by William Patty on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreDataCreator.h"

@implementation CoreDataCreator

-(id) init{
    self = [super init];
    if(self){
        
        
    }
    
    return self;
}

-(void) createCoreData{
    
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
    
}
@end
