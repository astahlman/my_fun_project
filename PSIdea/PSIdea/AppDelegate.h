//
//  AppDelegate.h
//  PSIdea
//
//  Created by William Patty on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventTableViewController.h"
#import "EventMapViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    EventTableViewController *eventTableViewController;
    EventMapViewController *eventMapViewController;
    UITabBarController *tabBarController;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
