//
//  ProfileViewController.h
//  PSIdea
//
//  Created by William Patty on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "POI.h"
#import "POIAnnotation.h"


@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    User *__user;
    NSArray *__userPOIs;
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIView *tableContainerView;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *profileTableViewCell;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;


-(id)initWithUser:(User*) user;

@end
