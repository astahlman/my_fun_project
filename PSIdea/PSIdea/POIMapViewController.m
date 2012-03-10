//
//  EventMapViewController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/24/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "POIMapViewController.h"

@implementation POIMapViewController
@synthesize poiMapView = __poiMapView;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize poiArray = __poiArray;
@synthesize visiblePOI = __visiblePOI;
@synthesize segmentedControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithContext:(NSManagedObjectContext *)context
{
    self = [super initWithNibName:@"POIMapView" bundle:[NSBundle mainBundle]];
    if (self) {
    __managedObjectContext = context;
    // set visiblePOI here...
        self.title = @"Map View";
    }
    return self;
}
-(void) getPOIs {
    __visiblePOI =nil;
    if (nearby) {
        //Search for public POI on server
        
    }
    else{
        //Use user saved POI (this will be downloaded and stored in CoreData
        __poiArray = [CoreDataManager fetchEntity:@"POI" fromContext:__managedObjectContext withPredicate:nil withSortKey:@"title" ascending:YES];
        __visiblePOI = [[NSMutableArray alloc] init];
        [__visiblePOI addObjectsFromArray:__poiArray];
    }
   
}

- (void) zoomToLocation:(CLLocationCoordinate2D) location animated: (BOOL) animated {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [__poiMapView setRegion:region animated:animated];
    __poiMapView.showsUserLocation = YES;
}

-(void) zoomOutToLocation:(CLLocationCoordinate2D) location animated:(BOOL) animated{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [__poiMapView setRegion:region animated:animated];
    __poiMapView.showsUserLocation = NO;

}
- (void) plotPOI {
    
    for (id<MKAnnotation> annotation in __poiMapView.annotations) {
        [__poiMapView removeAnnotation:annotation];
    }
    
    for (POI *poi in __visiblePOI) {
        
        CLLocationCoordinate2D location;
        location.latitude = poi.latitude.doubleValue;
        location.longitude = poi.longitude.doubleValue;
        POIAnnotation* annotation = [[POIAnnotation alloc] initWithDetails:poi.details coordinate:location title:poi.title];
        CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
       
        //Sets details to the address if nil;
        if(poi.details == nil){
            [annotation updateAnnotationView:annotationLocation];
        }
        [__poiMapView addAnnotation:annotation];
    }
    
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void) resetView{
    [self getPOIs];
    [self plotPOI];
    
}

-(void) createNewPOI{
    POICreationModalViewController *poiCreationMVC = [[POICreationModalViewController alloc] initWithManagedObjectContext:__managedObjectContext];
    poiCreationMVC.delegate = self;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:poiCreationMVC];
    UIImage *image = [UIImage imageNamed:@"navigationBarBackground"];
    [navCon.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault]; 
    [navCon.toolbar setBackgroundImage:image forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];  
    
    navCon.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self presentModalViewController:navCon animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    nearby = segmentedControl.selectedSegmentIndex;
    self.navigationItem.titleView = self.segmentedControl;
    [self resetView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewPOI)];
}


- (void)viewDidUnload
{
    [self setPoiMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewWillAppear:(BOOL)animated {  
    defaultRegion = __poiMapView.region;
        
    if (nearby) {
        __poiMapView.showsUserLocation = YES;

    }
    if (locationController==nil) {
        locationController = [[MYCLController alloc] init];
        locationController.delegate=self;
        [locationController.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    }

    [locationController.locationManager startUpdatingLocation];


     /*  CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 34.677035;
    zoomLocation.longitude = -86.452324;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 50*METERS_PER_MILE, 50*METERS_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [__poiMapView regionThatFits:viewRegion];                
    
    [__poiMapView setRegion:adjustedRegion animated:YES];   */     
}

-(IBAction)segmentSelected:(id)sender{
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            nearby = NO;
            [self zoomOutToLocation:currentLocation.coordinate animated:NO];
            break;
        case 1:
            nearby = YES;
            centeredAtUserLocation = YES;
            
            // TODO: Add nearby POIs on Server (i.e. friends POIs)
            [locationController.locationManager startUpdatingLocation];
            break;
        default:
            
            break;
            
    }

}
-(void) locationUpdate:(CLLocation *)location{
    currentLocation =location;
    [locationController.locationManager stopUpdatingLocation];
    if (nearby) {
        [self zoomToLocation:currentLocation.coordinate animated:NO];

    }
    
    else{
        [self zoomOutToLocation:currentLocation.coordinate animated:NO];

    }

}

-(void) locationError:(NSError *)error{
    NSLog(@"ERROR: %@", error);
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    if(centeredAtUserLocation){
        centeredAtUserLocation = NO;
        // TODO: add button so that user can get back to location after panning
    }
}

-(void) didFinishEditing:(BOOL)finished {
        if (YES) {
            [__managedObjectContext save:nil];
            
        }
    [self.modalViewController dismissModalViewControllerAnimated:YES];

}


@end
