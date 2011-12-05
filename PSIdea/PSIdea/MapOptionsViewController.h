//
//  MapOptionsViewController.h
//  PSIdea
//
//  Created by William Patty on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapOptionsViewControllerDelegate <NSObject>

@required
-(void) userDidDismissViewControllerWithResults: (NSArray*) results;

@end
@interface MapOptionsViewController : UIViewController{
    
    __weak IBOutlet UITableViewCell *customPublicCell;
    NSNumber  *makePublic;
    NSNumber *removePin;
    NSNumber  *mapViewOption;
    __weak IBOutlet UISwitch *tableViewCellSwitch;
    
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapViewType;
@property (weak, nonatomic) IBOutlet UITableView *groupedTableView;
@property (nonatomic, retain) id <MapOptionsViewControllerDelegate> delegate;

-(IBAction)removePinButtonSelected:(id)sender;
- (IBAction)mapTypeSlected:(id)sender;
-(id)initWithPublicSwitchState:(BOOL) isOn andMapType:(int) mapType;
@end
