//
//  ViewWithCoreData.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/28/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewWithCoreData <NSObject>

/* This method is responsible for the following:
    1. Set the managedObjectContext instance variable
    2. Pass the managedObjectContext to any subviews 
    (by invoking this method in the child view)
    3. Perform any view-specific set up that depends on core data
    (i.e., set the instance variables that will be used to populate
    a map view, table view, etc.)
 */
-(void)initWithContext:(NSManagedObjectContext*) context;

@end
