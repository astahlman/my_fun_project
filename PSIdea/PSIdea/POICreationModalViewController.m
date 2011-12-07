//
//  POICreationModalViewController.m
//  PSIdea
//
//  Created by William Patty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "POICreationModalViewController.h"

@implementation POICreationModalViewController
@synthesize infoButton;
@synthesize titleField;
@synthesize detailsField;
@synthesize miniMapView;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) done{
    [locationController.locationManager stopUpdatingLocation];
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
    NSNumber *public = [NSNumber numberWithBool:publicPOI];
    [POI createPOIWithID:idNumber andTitle:titleField.text andDetails:details andLatitude: latitude andLongitude:longitude andPhoto:nil andPublic:public andRating:nil andCreator:nil inManagedObjectContext:__managedObjectContext];
    //Create POI and Save context   
    [delegate didFinishEditing:YES];
}
-(void) cancel{
    miniMapView.showsUserLocation=NO;
    [locationController.locationManager stopUpdatingLocation];
    [delegate didFinishEditing:NO];

}
-(id)initWithManagedObjectContext:(NSManagedObjectContext*) context{
    self = [super initWithNibName:@"POICreationModalViewController" bundle:[NSBundle mainBundle]];
    if(self){
        __managedObjectContext = context;
        publicPOI = NO;

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
}

-(void) locationError:(NSError *)error{
    NSLog(@"ERROR: %@", error);
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
    
    detailsField.layer.cornerRadius = 10.0;
    detailsField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    detailsField.layer.borderWidth = 1.2;
    detailsField.layer.masksToBounds = YES;


    
}

-(void) viewWillAppear:(BOOL)animated{
    
    self.title = @"New POI";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    [titleField becomeFirstResponder];
    tapeImage.layer.shadowColor = [UIColor blackColor].CGColor;
    tapeImage.layer.shadowOffset = CGSizeMake(0, 1);
    tapeImage.layer.shouldRasterize = YES;
    tapeImage.layer.shadowOpacity = 0.8;
    tapeImage.layer.shadowRadius = 2.0;
    tapeImage.layer.contentsScale = [UIScreen mainScreen].scale;
/*    mainInfoView.layer.shadowColor = [UIColor blackColor].CGColor;
    mainInfoView.layer.shadowOffset = CGSizeMake(0, 1);
    mainInfoView.layer.shouldRasterize = NO;
    mainInfoView.layer.shadowOpacity = 1.0;
    mainInfoView.layer.shadowRadius = 20.0;
    mainInfoView.layer.contentsScale = [UIScreen mainScreen].scale;*/

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
    publicPOI = makePublic;
}
@end
