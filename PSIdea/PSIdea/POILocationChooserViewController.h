//
//  POILocationChooserViewController.h
//  PSIdea
//
//  Created by William Patty on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyCLController.h"
#import "POIAnnotation.h"
#import "MapOptionsViewController.h"

@protocol POILocationChooserViewControllerDelegate <NSObject>

@required
-(void) didSelectLocation: (CLLocation *) location WithPrivacy: (BOOL) makePublic;

@end

@interface POILocationChooserViewController : UIViewController  <MKMapViewDelegate, MyCLControllerDelegate,MapOptionsViewControllerDelegate>
{
    MYCLController *locationController;
    CLLocation *pinLocation;
    BOOL centerAtUserLocation;
    BOOL makePublic;

}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pageCurlButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *userLocationButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) id <POILocationChooserViewControllerDelegate> delegate;
-(id) initWithCurrentLocation: (CLLocation*) location;
-(void) locationUpdate:(CLLocation *)location;
-(void) locationError:(NSError *)error;
-(void) userDidDismissViewControllerWithResults:(NSArray *)results;
@end
