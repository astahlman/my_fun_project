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

@protocol POILocationChooserViewControllerDelegate <NSObject>

@required
-(void) didSelectLocation: (CLLocation *) location;

@end

@interface POILocationChooserViewController : UIViewController  <MKMapViewDelegate, MyCLControllerDelegate>
{
    MYCLController *locationController;
    CLLocation *pinLocation;

}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) id <POILocationChooserViewControllerDelegate> delegate;
-(id) initWithCurrentLocation: (CLLocation*) location;
-(void) locationUpdate:(CLLocation *)location;
-(void) locationError:(NSError *)error;
@end
