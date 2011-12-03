//
//  POILocationChooserViewController.m
//  PSIdea
//
//  Created by William Patty on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "POILocationChooserViewController.h"

@implementation POILocationChooserViewController
@synthesize mapView=__mapView;

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
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [__mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    
    
    
    POIAnnotation *annotation = [[POIAnnotation alloc] initWithDetails:@"Drag to drop at new Location" coordinate:touchMapCoordinate title:@"Dropped Pin"];
    [__mapView addAnnotation:annotation];
}

-(id) initWithCurrentLocation: (CLLocation*) location{
    self = [self initWithNibName:@"POILocationChooserViewController" bundle:[NSBundle mainBundle]];
    if(self){        
        currentLocation =location;

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

- (void) zoomToLocation:(CLLocation*) location {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [__mapView setRegion:region animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    __mapView.showsUserLocation = YES;
    // Do any additional setup after loading the view from its nib.
    [self zoomToLocation:currentLocation];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [__mapView addGestureRecognizer:lpgr];
    /*POIAnnotation *annotation = [[POIAnnotation alloc] initWithDetails:@"Drag to drop pin" coordinate:currentLocation.coordinate title:@"Drag to drop pin"];    
    [__mapView addAnnotation:annotation];*/
    

}

- (void)viewDidUnload
{
    [self setMapView:nil];
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
        
    }
}


@end
