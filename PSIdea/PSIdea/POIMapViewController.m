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
    __poiArray = [CoreDataManager fetchEntity:@"POI" fromContext:__managedObjectContext withPredicate:nil withSortKey:@"title" ascending:YES];
    __visiblePOI = [[NSMutableArray alloc] init];
    [__visiblePOI addObjectsFromArray:__poiArray];
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
- (void)viewDidLoad
{
    [super viewDidLoad];

    
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
    [self getPOIs];
    [self plotPOI];
  /*  CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 34.677035;
    zoomLocation.longitude = -86.452324;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 50*METERS_PER_MILE, 50*METERS_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [__poiMapView regionThatFits:viewRegion];                
    
    [__poiMapView setRegion:adjustedRegion animated:YES];   */     
}

@end
