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
        
        __poiArray = [CoreDataManager fetchEntity:@"POI" fromContext:__managedObjectContext withPredicate:nil withSortKey:@"title" ascending:YES];
        __visiblePOI = [[NSMutableArray alloc] init];
        [__visiblePOI addObjectsFromArray:__poiArray];
        // [self fetchNearbyPOIForCoordinate:currentLocation.coordinate];
        
        
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
    int tag = 0;
    for (POI *poi in __visiblePOI) {
        
        CLLocationCoordinate2D location;
        location.latitude = poi.latitude.doubleValue;
        location.longitude = poi.longitude.doubleValue;
        POIAnnotation* annotation = [[POIAnnotation alloc] initWithDetails:poi.details coordinate:location title:poi.title];
        annotation.tag = tag;
        CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        tag++;
        
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
    
    nearby = !(segmentedControl.selectedSegmentIndex);
    self.navigationItem.titleView = segmentedControl;
    [self resetView];
    
    // get pois for user testing
<<<<<<< HEAD

     
    // TESTING
=======
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:__managedObjectContext];
    User* user = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:__managedObjectContext];
    [user setTwitterHandle:@"PSI_Tester"];
    NSError* err;
    [__managedObjectContext save:&err];
    
    
>>>>>>> Added UUID for POIs
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"twitterHandle like %@", @"PSI_Tester"];
    NSArray* userResults = [CoreDataManager fetchEntity:@"User" fromContext:__managedObjectContext withPredicate:predicate withSortKey:nil ascending:YES];
    User* user;
    if ([userResults count] == 0)
    {
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:__managedObjectContext];
        user = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:__managedObjectContext];
        [user setTwitterHandle:@"PSI_Tester"];
        NSError* err;
        [__managedObjectContext save:&err]; 
    }
    else
    {
        assert([userResults count] == 1);
        user = [userResults objectAtIndex:0];
    }
    [[NetworkAPI apiInstance] getPOIsForUser:user callbackTarget:self action:@selector(operationDidGetPOIsForUser:) managedObjectContext:__managedObjectContext];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewPOI)];
    
    if (locationController==nil) {
        locationController = [[MYCLController alloc] init];
        locationController.delegate = self;
    }
    
    [locationController.locationManager startUpdatingLocation];
}


/// TESTING ONLY - REMOVE LATER
-(void)operationDidGetPOIsForUser:(HTTPSynchGetOperationWithParse*)operation
{
    NSString* responseString = [[NSString alloc] initWithData:[operation responseBody] encoding:NSUTF8StringEncoding];
    [[Logging logger] logMessage:responseString];
    NSArray* parsedResults = [operation parsedResults];
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
    
    if (nearby) {
        [self zoomToLocation:currentLocation.coordinate animated:NO];
        
    }
    
    else{
        [self zoomOutToLocation:currentLocation.coordinate animated:NO];
        
    }
    
    [self resetView];
}

-(IBAction)segmentSelected:(id)sender{
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            centeredAtUserLocation = YES;
            
            nearby = YES;
            [self zoomToLocation:currentLocation.coordinate animated:NO];
            
            break;
        case 1:
            nearby = NO;
            
            // TODO: Add nearby POIs on Server (i.e. friends POIs)
            [self zoomOutToLocation:currentLocation.coordinate animated:NO];
            
            
            break;
        default:
            
            break;
            
    }
    
    [self resetView];
    
    
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
        [self resetView];
        
    }
    [self.modalViewController dismissModalViewControllerAnimated:YES];
    
}

-(void)operationDidGetLocalPOIs:(HTTPSynchGetOperationWithParse*)operation
{
    NSString* responseString = [[NSString alloc] initWithData:[operation responseBody] encoding:NSUTF8StringEncoding];
    
    NSDictionary *responseDictionary = [responseString JSONValue];
    
    NSLog(@"%@",responseDictionary);
    //TODO: Plot Nearby POIs (Use different color from User's own POIs)
    
}

/*-(void) fetchNearbyPOIForCoordinate:(CLLocationCoordinate2D) coordinate{
 [[NetworkAPI apiInstance] getPOIsWithinRadius:1.0 ofLat:[NSNumber numberWithDouble:coordinate.latitude] ofLon:[NSNumber numberWithDouble:coordinate.longitude] callbackTarget:self action:@selector(operationDidGetLocalPOIs:) managedObjectContext:__managedObjectContext];
 }*/


-(MKAnnotationView  *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if(annotation == mapView.userLocation){
        return nil;
    }
    
    POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
    
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    }
    annotationView.draggable =YES;
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop =YES;
    annotationView.tag = poiAnnotation.tag;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    POI *desiredPOI = [__visiblePOI objectAtIndex:view.tag];
    
    POIDetailsViewController *poiDVC = [[POIDetailsViewController alloc] initWithPOI:desiredPOI];
    [self.navigationController pushViewController:poiDVC animated:YES];
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    currentLocation = userLocation.location;
    
}

-(void) locationUpdate:(CLLocation *)location{
    
    currentLocation = location;
    
    if (nearby) {
        [self zoomToLocation:currentLocation.coordinate animated:NO];
        
    }
    
    else{
        [self zoomOutToLocation:currentLocation.coordinate animated:NO];
        
    }
    
    
    [locationController.locationManager stopUpdatingLocation];
    
    
}

-(void) locationError:(NSError *)error{
    
}
@end
