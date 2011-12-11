//
//  List.m
//  PSIdea
//
//  Created by William Patty on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "List.h"
#import "POI.h"


@implementation List

@dynamic idNumber;
@dynamic title;
@dynamic pois;

+(List*) createDefaultListWithTitle:(NSString*)title InManagedObjectContext:(NSManagedObjectContext*)context{
    List *list = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    NSError *error = nil;
    
    list = [[context executeFetchRequest:request error:&error]lastObject];
    
    if(!list && !error){
        list = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
        list.idNumber = 0; //reserved for default
        list.title = title;
    }
    
    
    return list;
}

+(List*) createtListWithTitle:(NSString*)title withIDNumber: (NSNumber*) idNumber InManagedObjectContext:(NSManagedObjectContext*)context{
    List *list = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    NSError *error = nil;
    
    list = [[context executeFetchRequest:request error:&error]lastObject];
    
    if(!list && !error){
        list = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
        list.idNumber = idNumber; //reserved for default
        list.title = title;
    }
    
    
    return list;
}
+(List*) getDefaulListInMangedObjectContext:(NSManagedObjectContext*) context{
    List *list = nil;
    NSNumber *defaultId = 0;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"idNumber = %@",defaultId];
    NSError *error = nil;
    
    list = [[context executeFetchRequest:request error:&error]lastObject];
    
    if(error){
        list = nil;
    }
    
    return list;
}
@end
