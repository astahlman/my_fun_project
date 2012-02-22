//
//  ListEditingViewController.h
//  PSIdea
//
//  Created by William Patty on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "List.h"
#import "MWFSlideNavigationViewController.h"
#import <QuartzCore/QuartzCore.h>

@protocol ListEditingViewDelegate <NSObject>

@required

-(void) didSelectRow:(NSUInteger) row;

@end

@interface ListEditingViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *listArray;
    NSMutableArray *visibleList;
    NSManagedObjectContext *__managedObjectContext;
    UITextField *newListField, *activeField;
    BOOL keyboardIsShown;
}
@property (weak, nonatomic) IBOutlet UIView *intermediateView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *__tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@property (nonatomic,retain) id <ListEditingViewDelegate> delegate;


-(id)initWithContext:(NSManagedObjectContext *)context;



@property (weak, nonatomic) IBOutlet UITableViewCell *customCell;

@end
