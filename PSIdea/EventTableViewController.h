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

@interface EventTableViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *eventsArray;

- (void)loadEventsFromContext:(NSManagedObjectContext *)moc;

@end
