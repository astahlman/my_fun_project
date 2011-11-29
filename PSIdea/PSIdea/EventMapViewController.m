//
//  EventMapViewController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/24/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "EventMapViewController.h"

@implementation EventMapViewController
@synthesize eventMapView = __eventMapView;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize eventsArray = __eventsArray;
@synthesize visibleEvents = __visibleEvents;


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
    self = [super initWithNibName:@"EventMapView" bundle:[NSBundle mainBundle]];
    if (self) {
    __managedObjectContext = context;
    // set visibleEvents here...
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"All"];
    __eventsArray = [CoreDataManager fetchEntity:@"Event" fromContext:context withPredicate:nil withSortKey:@"title" ascending:YES];
    __visibleEvents = [[NSMutableArray alloc] init];
    [__visibleEvents addObjectsFromArray:__eventsArray];
        self.title = @"Map View";
    }
    return self;
}

- (void) plotEvents {
    
    for (id<MKAnnotation> annotation in __eventMapView.annotations) {
        [__eventMapView removeAnnotation:annotation];
    }
    
    for (Event *event in __visibleEvents) {
        
        CLLocationCoordinate2D location;
        location.latitude = event.latitude.doubleValue;
        location.longitude = event.longitude.doubleValue;
        EventAnnotation* annotation = [[EventAnnotation alloc] initWithDetails:event.details coordinate:location title:event.title];
        [__eventMapView addAnnotation:annotation];
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
    [self plotEvents];
}


- (void)viewDidUnload
{
    [self setEventMapView:nil];
    [self setEventMapView:nil];
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
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 34.677035;
    zoomLocation.longitude = -86.452324;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 50*METERS_PER_MILE, 50*METERS_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [__eventMapView regionThatFits:viewRegion];                
    
    [__eventMapView setRegion:adjustedRegion animated:YES];        
}

@end
