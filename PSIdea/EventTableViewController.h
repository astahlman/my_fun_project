//
//  EventTableViewController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventDetailsViewController.h"
#import "ViewWithCoreData.h"
#import "CoreDataManager.h"

@interface EventTableViewController : UITableViewController <ViewWithCoreData>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *eventTableView;

@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSMutableArray *visibleEvents;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end
