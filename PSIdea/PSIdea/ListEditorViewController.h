//
//  ListEditorModalViewController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 12/13/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"
#import "List.h"
#import "CoreDataManager.h"
#import "ViewWithCoreData.h"
#import "DraggableButton.h"
#import "GridViewController.h"
#import "POIButton.h"
#import "NetworkController.h"

@interface ListEditorViewController : UIViewController <ViewWithCoreData, DraggableButtonDelegate, NetworkControllerDelegate> // remove NetworkController later, for testing only

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIView *selectedListView;
@property (strong, nonatomic) IBOutlet UIScrollView *gridView;
@property (strong, nonatomic) GridViewController *gridViewController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *poiArray;
@property (nonatomic, retain) NSMutableArray *visiblePoi;
@property (nonatomic, retain) List* selectedList;
@property (nonatomic, retain) UIButton* listButton;

-(void)fetchTableViewDataInManagedObjectContext:(NSManagedObjectContext*)context;
-(IBAction)buttonReleased:(id)sender withEvent:(UIEvent*)event;

@end
