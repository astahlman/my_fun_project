//
//  POIScrollTableViewControllers.h
//  PSIdea
//
//  Created by William Patty on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "POIDetailsViewController.h"
#import "POI.h"
#import "CoreDataManager.h"
#import "POICreationModalViewController.h"
#import "ListEditorViewController.h"


@protocol POIScrollTableViewControllersDelegate <NSObject>

@required

-(void) editList:(NSNumber*) listNumber;
-(void) pushView:(UIViewController*) vc;
@end

@interface POIScrollTableViewControllers : UIViewController <POICreationModalViewControllerDelegate, UITableViewDelegate>
{
    NSString *__title;
    List *__list;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) int index;
@property (nonatomic, retain) NSMutableArray *poiArray;
@property (nonatomic, retain) NSMutableArray *visiblePOI;
@property (nonatomic, retain) List *list;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addPOIButton;
@property (weak, nonatomic) IBOutlet UITableView *poiTableView;

@property (nonatomic,retain) id <POIScrollTableViewControllersDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *intermediateView;
-(id)initWithList:(List *)list;
-(void) didFinishEditing:(BOOL)finished;
-(id)initWithContext:(NSManagedObjectContext *)context;
-(void) resetArrays;
-(IBAction)editListClicked:(id) sender;
@end
