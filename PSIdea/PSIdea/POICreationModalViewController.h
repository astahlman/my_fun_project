//
//  POICreationModalViewController.h
//  PSIdea
//
//  Created by William Patty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <stdlib.h>
#import "POI.h"
#import "CoreDataManager.h"
#import "POIAnnotation.h"
#import "MyCLController.h"
#import "POILocationChooserViewController.h"
@protocol POICreationModalViewControllerDelegate <NSObject>

@required
-(void) didFinishEditing:(BOOL) finished;
@end

@interface POICreationModalViewController : UIViewController <UITextViewDelegate, MyCLControllerDelegate,POILocationChooserViewControllerDelegate>{
    NSManagedObjectContext *__managedObjectContext;
    __weak IBOutlet UIImageView *tapeImage;
    MYCLController *locationController;
    __weak IBOutlet UIView *mainInfoView;
    CLLocation *currentLocation;
 
}
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet MKMapView *miniMapView;


@property (nonatomic, retain) id <POICreationModalViewControllerDelegate> delegate;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*) context;
-(void) didSelectLocation: (CLLocation*) location;
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (IBAction)infoButtonSelected:(id)sender;

@end
