//
//  TabBarViewController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventTableViewController.h"
#import "EventMapViewController.h"

@interface TabBarViewController : UITabBarController 

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet EventTableViewController *eventTableViewController;
@property (nonatomic, retain) IBOutlet EventMapViewController *eventMapViewController;

@end
