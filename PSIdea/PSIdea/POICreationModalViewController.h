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

// Delegate Setup

@protocol POICreationModalViewControllerDelegate <NSObject>

@required
-(void) didFinishEditing:(BOOL) finished;
@end

@class HTTPSynchPostOperationWithParse;


@interface POICreationModalViewController : UIViewController <UITextViewDelegate, MyCLControllerDelegate, POILocationChooserViewControllerDelegate>
{
    NSManagedObjectContext *__managedObjectContext;
    __weak IBOutlet UIView *mainInfoView;
    CLLocation *currentLocation;
    BOOL tweetPOI;
    MyCLController *locationController;
 
}
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;
@property (nonatomic, retain) id <POICreationModalViewControllerDelegate> delegate;


 // UIButton action methods

- (IBAction)tweetButtonSelected:(id)sender;
- (IBAction)infoButtonSelected:(id)sender;

// Custome Initialization Method
-(id)initWithManagedObjectContext:(NSManagedObjectContext*) context;

// POILocationChooserViewController Delegate Method

-(void) didSelectLocation: (CLLocation *) location WithAddress:(NSString*) address;

- (NSString *)GetUUID;

-(void)postOperationFinished:(HTTPSynchPostOperationWithParse*)operation;
//-(void)operation:(HTTPOperation*)operation didFailWithError:(NSString*)errorMsg;
//-(void)operation:(HTTPPostOperation*)operation didPostAndReceivePrimaryKey:(id)primaryKey;

-(void) locationUpdate:(CLLocation *)location;
-(void) locationError:(NSError *)error;


@end
