//
//  EventDetailsViewController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "POIDetailsViewController.h"

@implementation POIDetailsViewController

@synthesize dateLabel = _dateLabel;
@synthesize creatorNameLabel = _creatorNameLabel;
@synthesize creatorLabel = _creatorLabel;
@synthesize userPhotoImageView = _userPhotoImageView;
@synthesize titleLabel = __titleLabel;
@synthesize detailsTextView = __detailsTextView;
@synthesize disclosureButton = _disclosureButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (id)initWithPOI: (POI*) poi {
    self = [super initWithNibName:@"POIDetailsView" bundle:[NSBundle mainBundle]];
    if (self) {
        __poi = poi;
        __details = poi.details;
        __title = poi.title;
        pinLocation = [[CLLocation alloc] initWithLatitude: poi.latitude.floatValue longitude:poi.longitude.floatValue];
        self.title =@"Details";
        __creatorUserName = poi.creator.twitterHandle;
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailsTextView.text = __details;
    self.titleLabel.text = __title;
    self.creatorLabel.text = __creatorUserName;
    NSString *twitterHandle = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterHandle"];
    
    if ([__creatorUserName isEqualToString:twitterHandle]) {
        UIImage *image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoto"]];
        
        _userPhotoImageView.image = image;
        
        self.creatorNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey: @"name"];
        
    }
    
    NSString *details;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSDate *date = __poi.creationDate;
    //Set the required date format
    
    [formatter setDateFormat:@"hh:mm a"];
    
    //Get the string date
    NSString *timeString  = [formatter stringFromDate:date];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    // Your dates:
    NSDate * today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400]; //86400 is the seconds in a day
    NSDate * refDate = __poi.creationDate;
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString]) 
    {
        details = [NSString stringWithFormat:@"Today at %@",timeString];
    } else if ([refDateString isEqualToString:yesterdayString]) 
    {
        details = [NSString stringWithFormat:@"Yesterday at %@",timeString];
    } else 
    {
        details = [NSString stringWithFormat:@"%@ at %@",dateString, timeString];
    }
    
    _dateLabel.text =details;
    /* Added for future use (if needed). Uncomment action sheet methods above  
     
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(handleAction)];
     */
    
    
    containerView.layer.cornerRadius = 10.0;
    containerView.layer.borderColor = [UIColor clearColor].CGColor;
    containerView.layer.borderWidth = 1.2;
    containerView.layer.masksToBounds = YES;
    
}


- (void)viewDidUnload
{
    containerView = nil;
    [self setCreatorLabel:nil];
    [self setCreatorNameLabel:nil];
    [self setUserPhotoImageView:nil];
    [self setDisclosureButton:nil];
    [self setDateLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)disclosureButtonSelected:(id)sender {
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithUser:__poi.creator];
    [self.navigationController pushViewController:pvc animated:YES];
    
}

@end
