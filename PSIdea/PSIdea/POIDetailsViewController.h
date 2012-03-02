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
#import "MyCLController.h"
#import "POIAnnotation.h"

@interface POIDetailsViewController : UIViewController <MKMapViewDelegate>{
    
    CLLocation *pinLocation;
    NSString *__title;
    NSString *__details;
    __weak IBOutlet UIView *containerView;
}

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UITextView* detailsTextView;
@property (weak, nonatomic) IBOutlet MKMapView *__mapView;

- (id)initWithPOI:(POI*) poi;

@end
