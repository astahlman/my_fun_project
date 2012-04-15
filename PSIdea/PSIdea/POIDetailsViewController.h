//
//  EventDetailsViewController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "POI.h"
#import "User.h"
#import "MyCLController.h"
#import "POIAnnotation.h"
#import "ProfileViewController.h"

@interface POIDetailsViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>{
    
    CLLocation *pinLocation;
    NSString *__title;
    NSString *__details;
    NSString *__creatorUserName;
    POI *__poi;
    __weak IBOutlet UIView *containerView;
}

// Public Class Variables 
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UITextView* detailsTextView;
@property (weak, nonatomic) IBOutlet UIButton *disclosureButton;

// Class Methods

- (id)initWithPOI:(POI*) poi;
- (IBAction)disclosureButtonSelected:(id)sender;

@end
