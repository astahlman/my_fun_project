//
//  EventTableViewController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"
#import "POIDetailsViewController.h"
#import "ViewWithCoreData.h"
#import "CoreDataManager.h"
#import "POICreationModalViewController.h"


@interface POITableViewController : UITableViewController <ViewWithCoreData, POICreationModalViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *poiTableView;

@property (nonatomic, retain) NSMutableArray *poiArray;
@property (nonatomic, retain) NSMutableArray *visiblePOI;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

-(id)initWithContext:(NSManagedObjectContext *)context;
-(void) didFinishEditing:(BOOL)finished;
@end
