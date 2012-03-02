//
//  EventDetailsViewController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "POIDetailsViewController.h"

@implementation POIDetailsViewController

@synthesize titleLabel = __titleLabel;
@synthesize detailsTextView = __detailsTextView;
@synthesize __mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPOI: (POI*) poi {
    self = [super initWithNibName:@"POIDetailsView" bundle:[NSBundle mainBundle]];
    if (self) {
       __details = poi.details;
        __title = poi.title;
        pinLocation = [[CLLocation alloc] initWithLatitude: poi.latitude.floatValue longitude:poi.longitude.floatValue];
        self.title = __title;
    }

    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
- (void) zoomToLocation:(CLLocationCoordinate2D) location animated: (BOOL) animated {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [__mapView setRegion:region animated:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailsTextView.text = __details;
    self.titleLabel.text = __title;
    
    [self zoomToLocation:pinLocation.coordinate animated:NO];
    POIAnnotation *annotation = [[POIAnnotation alloc] initWithDetails:nil coordinate:pinLocation.coordinate title:nil];
    [annotation updateAnnotationView:pinLocation];
    [__mapView addAnnotation:annotation];
    
    containerView.layer.cornerRadius = 10.0;
    containerView.layer.borderColor = [UIColor clearColor].CGColor;
    containerView.layer.borderWidth = 1.2;
    containerView.layer.masksToBounds = YES;
    
    __mapView.layer.cornerRadius = 10.0;
    __mapView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    __mapView.layer.borderWidth = 2.0;
    __mapView.layer.masksToBounds = YES;


}


- (void)viewDidUnload
{
    containerView = nil;
    [self set__mapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
