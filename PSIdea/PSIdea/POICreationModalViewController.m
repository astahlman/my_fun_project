//
//  POICreationModalViewController.m
//  PSIdea
//
//  Created by William Patty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "POICreationModalViewController.h"
#import "PSINetworkController.h"
#import "NSManagedObject+PropertiesDict.h"
#import "NetworkAPI.h"
#import "Logging.h"

@implementation POICreationModalViewController

@synthesize infoButton;
@synthesize titleField;
@synthesize detailsField;
@synthesize miniMapView;
@synthesize publicButton;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)operationDidGetLocalPOIs:(HTTPSynchGetOperationWithParse*)operation
{
    NSString* responseString = [[NSString alloc] initWithData:[operation responseBody] encoding:NSUTF8StringEncoding];
    [[Logging logger] logMessage:responseString];
}

-(void)done
{
    miniMapView.showsUserLocation=NO;
    // need to pass in user id for user logged in.
    int number = arc4random() % 10000; // This will need to change. Could get same number multiple times
    NSNumber *idNumber = [NSNumber numberWithInt:number];
    
    NSNumber *latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    NSString *details = detailsField.text;
    if ([detailsField.text isEqualToString:@"Click here to add details."]) {
        details = nil;
    }
    
    POI* poi = [POI createPOIWithID:idNumber andTitle:titleField.text andDetails:details andLatitude: latitude andLongitude:longitude andPhoto:nil andRating:nil andCreator:nil  inManagedObjectContext:__managedObjectContext];
    [[NetworkAPI apiInstance] postPOI:poi callbackTarget:self action:@selector(postOperationFinished:)];
    
    
    // local poi testing
    [[NetworkAPI apiInstance] getPOIsWithinRadius:1.0 ofLat:latitude ofLon:longitude callbackTarget:self action:@selector(operationDidGetLocalPOIs:)];
    [delegate didFinishEditing:YES];
}

-(void)postOperationFinished:(HTTPSynchPostOperationWithParse*)operation
{
    if (operation.operationState != OperationStateFailed)
    {
        NSError* saveErr;
        [__managedObjectContext save:&saveErr];
        if (saveErr != nil)
        {
            [[Logging logger] logMessage:@"Error: Post entity not saved in managedObjectContext"];
        }
    }
}
     
-(void)cancel
{
    miniMapView.showsUserLocation=NO;
    [locationController.locationManager stopUpdatingLocation];
    [delegate didFinishEditing:NO];
}

-(id)initWithManagedObjectContext:(NSManagedObjectContext*) context{
    self = [super initWithNibName:@"POICreationModalViewController" bundle:[NSBundle mainBundle]];
    if (self)
    {
        __managedObjectContext = context;
        tweetPOI = NO;
    }
    
    return self;
}
- (void) zoomToLocation:(CLLocation*) location {
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [miniMapView setRegion:region animated:NO];
}

-(void) locationUpdate:(CLLocation *)location{
    currentLocation =location;
    [self zoomToLocation:location];
    POIAnnotation *annotation = [[POIAnnotation alloc] initWithDetails:nil coordinate:currentLocation.coordinate title:nil];
    for (id<MKAnnotation> annotation in miniMapView.annotations) {
        [miniMapView removeAnnotation:annotation];
    }
    [miniMapView addAnnotation:annotation];
    
    [locationController.locationManager stopUpdatingLocation];
}

-(void) locationError:(NSError *)error{
    NSLog(@"ERROR: %@", error);
    
    [locationController.locationManager stopUpdatingLocation];
    [locationController.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    miniMapView.showsUserLocation=NO;
    locationController = [[MYCLController alloc] init];
    locationController.delegate=self;
    [locationController.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationController.locationManager startUpdatingLocation];
    
    backgroundImageView.layer.cornerRadius = 10.0;
    backgroundImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    backgroundImageView.layer.borderWidth = 1.2;
    backgroundImageView.layer.masksToBounds = YES;
    [ publicButton setImage:[UIImage imageNamed:@"button_unselected"]forState:UIControlStateNormal];
    tweetPOI = NO;

}

-(void) viewWillAppear:(BOOL)animated
{
    
    self.title = @"New POI";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    [titleField becomeFirstResponder];
    
}

- (void)viewDidUnload
{
    [self setTitleField:nil];
    [self setDetailsField:nil];
    [self setMiniMapView:nil];
    tapeImage = nil;
    mainInfoView = nil;
    [self setInfoButton:nil];
    backgroundImageView = nil;
    [self setPublicButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)infoButtonSelected:(id)sender{
    
    //Push a bigger map View that allows user to drop pin at location
    //expand off current map class?
    POILocationChooserViewController *locationChooserVC = [[POILocationChooserViewController alloc] initWithCurrentLocation:currentLocation];
    locationChooserVC.delegate = self;
    [self.navigationController pushViewController:locationChooserVC animated:YES];
    
}
-(void) textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Click here to add details."]) {
        textView.text=@"";
    }
}

-(void) didSelectLocation: (CLLocation*) location WithPrivacy:(BOOL)makePublic{
    [self zoomToLocation:location];
    //Add annotation to miniMapView
    
    POIAnnotation *annotation = [[POIAnnotation alloc] initWithDetails:nil coordinate:location.coordinate title:nil];
    for (id<MKAnnotation> annotation in miniMapView.annotations) {
        [miniMapView removeAnnotation:annotation];
    }
    [miniMapView addAnnotation:annotation];
    currentLocation = location;
    tweetPOI = makePublic;
}
- (IBAction)publicButtonSelected:(id)sender {
    
    //Need to update this to control Tweeting and Rename
    
    if (tweetPOI  == YES) {
        
        [ publicButton setImage:[UIImage imageNamed:@"button_unselected"]forState:UIControlStateNormal];
        tweetPOI = NO;
    }
    else{
        
        [ publicButton setImage:[UIImage imageNamed:@"button_selected"]forState:UIControlStateNormal];
        tweetPOI = YES;
    }
}
@end
