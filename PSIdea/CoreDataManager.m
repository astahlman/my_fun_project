//
//  CoreDataManager.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/28/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

+(NSMutableArray*) fetchEntity:(NSString*)entityName fromContext:(NSManagedObjectContext*)context withPredicate:(NSPredicate*)predicate withSortKey:(NSString*)sortKey ascending:(BOOL)isAscending
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:isAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }    
    return mutableFetchResults;
}

@end
