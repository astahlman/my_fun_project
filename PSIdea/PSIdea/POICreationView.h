//
//  POICreationView.h
//  PSIdea
//
//  Created by William Patty on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface POICreationView : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailsView;

@end
