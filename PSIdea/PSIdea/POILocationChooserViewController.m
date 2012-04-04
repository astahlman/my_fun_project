//
//  POILocationChooserViewController.m
//  PSIdea
//
//  Created by William Patty on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "POILocationChooserViewController.h"

@implementation POILocationChooserViewController
@synthesize pageCurlButton;
@synthesize userLocationButton;
@synthesize mapView=__mapView;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    if(__mapView.annotations.count >1) {
     
        for (id<MKAnnotation> annotation in __mapView.annotations) {
            if(annotation!=__mapView.userLocation){
                [__mapView removeAnnotation:annotation];
                
            }
                
        }

    }
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [__mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    
    POIAnnotation *annotation = [[POIAnnotation alloc] initWithDetails:@"Drag to drop at new Location" coordinate:touchMapCoordinate title:@"Dropped Pin"];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [annotation updateAnnotationView:location];
    [__mapView addAnnotation:annotation];
    userLocationButton.style = UIBarButtonItemStyleBordered;
    locationAddress = annotation.details;
}

-(id) initWithCurrentLocation: (CLLocation*) location{
    self = [self initWithNibName:@"POILocationChooserViewController" bundle:[NSBundle mainBundle]];
    if(self){        
        pinLocation =location;
        self.title = @"POI Location";
        makePublic = NO;
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

- (void) zoomToLocation:(CLLocationCoordinate2D) location animated: (BOOL) animated {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.002, 0.002);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [__mapView setRegion:region animated:animated];
}
-(void) handlePanGesture:(UIGestureRecognizer *)gestureRecognizer 
{
    if(gestureRecognizer.state == UIGestureRecognizerStateRecognized){
        userLocationButton.style = UIBarButtonItemStyleBordered;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    locationController = [[MYCLController alloc] init];
    [locationController.locationManager startUpdatingLocation];
    locationController.delegate =self;
    __mapView.showsUserLocation = YES;
    // Do any additional setup after loading the view from its nib.
    [self zoomToLocation:pinLocation.coordinate animated:NO];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
   // UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [__mapView addGestureRecognizer:lpgr];
    //[__mapView addGestureRecognizer:pgr];
    
    self.navigationItem.rightBarButtonItem = userLocationButton;

}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setUserLocationButton:nil];
    [self setPageCurlButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(MKAnnotationView  *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if(annotation == mapView.userLocation){
        return nil;
    }
    POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;

    CLLocation *location = [[CLLocation alloc] initWithLatitude:poiAnnotation.coordinate.latitude longitude:poiAnnotation.coordinate.longitude];
    [poiAnnotation updateAnnotationView:location];
    pinLocation = location;
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    }
    annotationView.draggable =YES;
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop =YES;

    return annotationView;
}
-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    if(MKAnnotationViewDragStateEnding){
        POIAnnotation *annotation = (POIAnnotation*)view.annotation;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        [annotation updateAnnotationView:location];
        pinLocation = location;
     
    }
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    if(centerAtUserLocation){
        userLocationButton.style = UIBarButtonItemStyleBordered;
        centerAtUserLocation = NO;

    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [delegate didSelectLocation:pinLocation WithAddress:@"Current Location"];

}

-(void) locationUpdate:(CLLocation *)location{
     
    if (pinLocation.coordinate.latitude != location.coordinate.latitude &&
        pinLocation.coordinate.longitude != location.coordinate.longitude) {
        POIAnnotation *annotation = [[POIAnnotation alloc] initWithDetails:@"Drag to drop pin" coordinate:pinLocation.coordinate title:@"Dropped Pin"];   
        [annotation updateAnnotationView:location];
        [__mapView addAnnotation:annotation];
    }
        if(centerAtUserLocation){
        [self zoomToLocation:location.coordinate animated:NO];
    }

    [locationController.locationManager stopUpdatingLocation];
}
-(void) locationError:(NSError *)error{
    
}

-(IBAction)userLocationButtonSelected:(id)sender{
    userLocationButton.style = UIBarButtonItemStyleDone;
    __mapView.showsUserLocation = YES;
    if (!centerAtUserLocation) {
        [self zoomToLocation:__mapView.userLocation.coordinate animated:YES];
        centerAtUserLocation = YES;
    }

}

-(IBAction)pageCurlButtonSelected:(id)sender{

    MapOptionsViewController *optionsView = [[MapOptionsViewController alloc] initWithPublicSwitchState:makePublic];
    optionsView.delegate = self;
           [optionsView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [optionsView setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    self.navigationController.hidesBottomBarWhenPushed = NO;
    [self presentModalViewController:optionsView animated:YES];
  
}

-(void) userDidDismissViewControllerWithResults:(NSArray *)results{

    NSNumber *public = [results objectAtIndex:0];
    NSNumber *removePin = [results objectAtIndex:1];
    makePublic = NO;
    if([public isEqualToNumber:[NSNumber numberWithInt:1]]){
        makePublic = YES;
    }
    if([removePin isEqualToNumber:[NSNumber numberWithInt:1]]){
        for (id<MKAnnotation> annotation in __mapView.annotations) {
            if(annotation!=__mapView.userLocation){
                [__mapView removeAnnotation:annotation];

            }
        }
    }
    

     [self dismissModalViewControllerAnimated:YES];
}

@end
