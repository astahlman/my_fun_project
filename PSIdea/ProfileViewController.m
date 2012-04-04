//
//  ProfileViewController.m
//  PSIdea
//
//  Created by William Patty on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize profileTableViewCell;
@synthesize profileTableView;
@synthesize userPhoto;
@synthesize userNameLabel;
@synthesize twitterHandleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithUser:(User*) user{
    
    self = [self initWithNibName:@"ProfileViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        __user = user;
        NSSortDescriptor *sortNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortNameDescriptor, nil];
        __userPOIs = [[user.pois allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        
        NSLog(@"User Pois: %@", __userPOIs);

    }
    return self;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    twitterHandleLabel.text = __user.twitterHandle;
        //Add profile Photo
   /* NSData *imageData = [NSData alloc] initWithContentsOfURL:__user.
    UIImage *image = [UIImage imageWithData:*/
    NSString *twitterHandle = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterHandle"];

    if ([__user.twitterHandle isEqualToString:twitterHandle]) {
        UIImage *image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoto"]];
        
        userPhoto.image = image;
        
    }

    containerView.layer.cornerRadius = 10.0;
    containerView.layer.borderColor = [UIColor clearColor].CGColor;
    containerView.layer.borderWidth = 1.2;
    containerView.layer.masksToBounds = YES;
    tableContainerView.layer.cornerRadius = 10.0;
    tableContainerView.layer.borderColor = [UIColor clearColor].CGColor;
    tableContainerView.layer.borderWidth = 1.2;
    tableContainerView.layer.masksToBounds = YES;
    
    
    
}

- (void)viewDidUnload
{
    [self setProfileTableViewCell:nil];
    [self setProfileTableView:nil];
    [self setUserPhoto:nil];
    [self setUserNameLabel:nil];
    [self setTwitterHandleLabel:nil];
    containerView = nil;
    tableContainerView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Add TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    
    return [__userPOIs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"profileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ProfileTableViewCell" owner:self options:nil];
        cell = profileTableViewCell;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.profileTableViewCell = nil;
    }
    
    POI *cellPOI = [__userPOIs objectAtIndex:indexPath.row];
    
    UILabel *titleLabel;
    UILabel *detailsLabel;
    MKMapView *mapView;

    titleLabel = (UILabel*) [cell viewWithTag:2];
    titleLabel.text = cellPOI.title;
    
    detailsLabel = (UILabel*) [cell viewWithTag:3];
    detailsLabel.text = cellPOI.details;
    
    mapView = (MKMapView*)[cell viewWithTag:1];
    mapView.userInteractionEnabled = NO;
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    int tag = 0;

        
        CLLocationCoordinate2D location;
        location.latitude = cellPOI.latitude.doubleValue;
        location.longitude = cellPOI.longitude.doubleValue;
        POIAnnotation* annotation = [[POIAnnotation alloc] initWithDetails:cellPOI.details coordinate:location title:cellPOI.title];
        annotation.tag = tag;
        CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        tag++;
        
        //Sets details to the address if nil;
        if(cellPOI.details == nil){
            [annotation updateAnnotationView:annotationLocation];
        }
        [mapView addAnnotation:annotation];
    
#define LOCATIONDIFF 0.0003;
    
    CLLocationCoordinate2D modLocation;
    modLocation.latitude = location.latitude + LOCATIONDIFF;
    modLocation.longitude = location.longitude + 0.0001;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion region = MKCoordinateRegionMake(modLocation, span);
    [mapView setRegion:region animated:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.    
    // ...
    // Pass the selected object to the new view controller.

    
}

@end
