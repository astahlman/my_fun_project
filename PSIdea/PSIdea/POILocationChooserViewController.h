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

@interface POILocationChooserViewController : UIViewController  <MKMapViewDelegate>
{
    MYCLController *locationController;
    CLLocation *currentLocation;

}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(id) initWithCurrentLocation: (CLLocation*) location;

@end
