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
#import "TWRequestOperation.h"

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

-(void)operationDidGetFollowed:(TWRequestOperation*)operation
{
    NSArray* followed = [operation.responseDict valueForKey:@"screenNames"];
    [[Logging logger] logMessage:[NSString stringWithFormat:@"Here are the followed screen names: %@", followed]];
}

-(void)done
{
    // need to pass in user id for user logged in.
   // int number = arc4random() % 10000; // This will need to change. Could get same number multiple times
//    NSNumber *idNumber = [NSNumber numberWithInt:number];
    
    //Use UDID as id 
    
    NSString *idString = [self GetUUID];  
    
   // NSLog(@"%@", idNumber);
    
    NSNumber *latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    NSString *details = detailsField.text;
    if ([detailsField.text isEqualToString:@"Click here to add details."]) {
        details = nil;
    }
    
    POI* poi = [POI createPOIWithID:idString andTitle:titleField.text andDetails:details andLatitude: latitude andLongitude:longitude andPhoto:nil andRating:nil andCreator:nil  inManagedObjectContext:__managedObjectContext];
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
            NSString* urlExtension = [NSString stringWithFormat:@"/view_poi/%@/", thePoi.idString];
            NSString* url = [[NetworkAPI getURLBase] stringByAppendingString:urlExtension];
            NSString* tweetBody = [NSString stringWithFormat:@"%@ %@", thePoi.details, url];
            [[TwitterAPI apiInstance] sendTweet:tweetBody forHandle:twitterHandle callbackTarget:self action:@selector(finishedTweet:)];
        }
    }
}


-(void)finishedTweet:(TWRequestOperation*)operation
{
    if (operation.operationState == OperationStateSuccess)
    {
        [[Logging logger] logMessage:@"Tweet sent successfully"];
    }
    else
    {
        [[Logging logger] logMessage:@"Tweet not sent"];
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
        NSString* twitterHandle = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterHandle"];
        [[TwitterAPI apiInstance] getFollowed:twitterHandle callbackTarget:self action:@selector(operationDidGetFollowed:)];
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
        
    [ publicButton setImage:[UIImage imageNamed:@"button_selected"]forState:UIControlStateNormal];
    tweetPOI = YES;
       [ publicButton setImage:[UIImage imageNamed:@"button_unselected"]forState:UIControlStateNormal];
    
   // View Setup (rounded Corners) 


    tweetPOI = NO;
    mainInfoView.layer.cornerRadius = 10.0;
    mainInfoView.layer.borderColor = [UIColor clearColor].CGColor;
    mainInfoView.layer.borderWidth = 1.2;
    mainInfoView.layer.masksToBounds = YES;
    
    locationLabel.text = @"Current Location";
    locationController = [[MyCLController alloc] init];
    [locationController.locationManager startUpdatingLocation];
    locationController.delegate =self;
    
    
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

-(void) locationUpdate:(CLLocation *)location{
    currentLocation = location;
    [locationController.locationManager stopUpdatingLocation];
    
}

-(void) locationError:(NSError *)error{
    NSLog(@"%@", error);
}
@end
