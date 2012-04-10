//
//  MapOptionsViewController.h
//  PSIdea
//
//  Created by William Patty on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Delegate Setup

@protocol MapOptionsViewControllerDelegate <NSObject>

@required

-(void) userDidDismissViewControllerWithResults: (NSArray*) results;

@end

@interface MapOptionsViewController : UIViewController{
    
    __weak IBOutlet UITableViewCell *customPublicCell;
    NSNumber  *makePublic;
    NSNumber *removePin;
    __weak IBOutlet UISwitch *tableViewCellSwitch;
    __weak IBOutlet UIButton *removePinButton;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPinButtonImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapViewType;
@property (nonatomic, retain) id <MapOptionsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundButtonImage;

// UIButton action methods

-(IBAction)userDidTouchDownOnButton:(id)sender;
-(IBAction)userDidCancelPress:(id)sender;
-(IBAction)removePinButtonSelected:(id)sender;

// Iniitialization Method

-(id)initWithPublicSwitchState:(BOOL) isOn;

@end
