//
//  AppDelegate.h
//  PSIdea
//
//  Created by William Patty on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIMapViewController.h"
#import "MWFSlideNavigationViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    POIMapViewController *__poiMapViewController;
    UITabBarController *__tabBarController;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (nonatomic, retain) UINavigationController *thirdNavCon;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end
