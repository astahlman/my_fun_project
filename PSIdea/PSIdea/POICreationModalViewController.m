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
#import "TwitterAPI.h"
#import "Logging.h"
#import "CoreDataEntities.h"

@implementation POICreationModalViewController

@synthesize locationLabel;
@synthesize infoButton;
@synthesize titleField;
@synthesize detailsField;
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

/// TESTING ONLY - REMOVE LATER
-(void)operationDidGetLocalPOIs:(HTTPSynchGetOperationWithParse*)operation
{
    NSString* responseString = [[NSString alloc] initWithData:[operation responseBody] encoding:NSUTF8StringEncoding];
    [[Logging logger] logMessage:responseString];
    NSArray* parsedResults = [operation parsedResults];
}

-(void)done
{
    // need to pass in user id for user logged in.
   // int number = arc4random() % 10000; // This will need to change. Could get same number multiple times
//    NSNumber *idNumber = [NSNumber numberWithInt:number];
    
    //Use UDID as id 
    
    NSString *idNumber = [self GetUUID];  
    
   // NSLog(@"%@", idNumber);
    
    NSNumber *latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    NSString *details = detailsField.text;
    if ([detailsField.text isEqualToString:@"Click here to add details."]) {
        details = nil;
    }
    
    POI* poi = [POI createPOIWithID:idNumber andTitle:titleField.text andDetails:details andLatitude: latitude andLongitude:longitude andPhoto:nil andRating:nil andCreator:nil  inManagedObjectContext:__managedObjectContext];
    [[NetworkAPI apiInstance] postPOI:poi callbackTarget:self action:@selector(postOperationFinished:)];
    /*
     // local poi testing
     [[NetworkAPI apiInstance] getPOIsWithinRadius:1.0 ofLat:latitude ofLon:longitude callbackTarget:self action:@selector(operationDidGetLocalPOIs:) managedObjectContext:__managedObjectContext];
     */
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
        if (tweetPOI)
        {
            POI* thePoi = (POI*) (operation.postEntity);
            // TODO: Provide some sort of drop-down or something to let user's select account
            NSString* twitterHandle = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterHandle"];
            NSString* urlExtension = [NSString stringWithFormat:@"/view_poi/%@/", thePoi.idNumber];
            NSString* url = [[NetworkAPI getURLBase] stringByAppendingString:urlExtension];
            NSString* tweetBody = [NSString stringWithFormat:@"%@ %@", thePoi.details, url];
            [[TwitterAPI apiInstance] sendTweet:tweetBody forHandle:twitterHandle];
        }
    }
}

-(void)cancel
{
    [delegate didFinishEditing:NO];
}

-(id)initWithManagedObjectContext:(NSManagedObjectContext*) context{
    self = [super initWithNibName:@"POICreationModalViewController" bundle:[NSBundle mainBundle]];
    if (self)
    {
        __managedObjectContext = context;
        tweetPOI = YES;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
<<<<<<< HEAD
    miniMapView.showsUserLocation=NO;
    locationController = [[MYCLController alloc] init];
    locationController.delegate=self;
    [locationController.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationController.locationManager startUpdatingLocation];
    
    backgroundImageView.layer.cornerRadius = 10.0;
    backgroundImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    backgroundImageView.layer.borderWidth = 1.2;
    backgroundImageView.layer.masksToBounds = YES;
    [ publicButton setImage:[UIImage imageNamed:@"button_selected"]forState:UIControlStateNormal];
    tweetPOI = YES;
=======
       [ publicButton setImage:[UIImage imageNamed:@"button_unselected"]forState:UIControlStateNormal];
    
   // View Setup (rounded Corners) 


    tweetPOI = NO;
>>>>>>> Added UUID for POIs
    mainInfoView.layer.cornerRadius = 10.0;
    mainInfoView.layer.borderColor = [UIColor clearColor].CGColor;
    mainInfoView.layer.borderWidth = 1.2;
    mainInfoView.layer.masksToBounds = YES;
    
    locationLabel.text = @"Current Location";
    
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
    mainInfoView = nil;
    [self setInfoButton:nil];
    [self setPublicButton:nil];
    [self setLocationLabel:nil];
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

-(void) didSelectLocation: (CLLocation *) location WithAddress:(NSString*) address{
    currentLocation = location;    
    locationLabel.text = address;
    
    CLGeocoder *__coder = [[CLGeocoder alloc] init];
    
    [__coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject];
        locationLabel.text = [placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressStreetKey];
    }];
}


-(IBAction)tweetButtonSelected:(id)sender{
    
    //Need to update this to control Tweeting
    
    if (tweetPOI  == YES) {
        
        [ publicButton setImage:[UIImage imageNamed:@"button_unselected"]forState:UIControlStateNormal];
        tweetPOI = NO;
    }
    else{
        
        [ publicButton setImage:[UIImage imageNamed:@"button_selected"]forState:UIControlStateNormal];
        tweetPOI = YES;
    }
}

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
}
@end
