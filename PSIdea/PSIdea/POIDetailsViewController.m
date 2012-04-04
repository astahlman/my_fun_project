//
//  EventDetailsViewController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "POIDetailsViewController.h"

@implementation POIDetailsViewController

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


/*-(void) handleAction{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Place?" otherButtonTitles: nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet dismissWithClickedButtonIndex:actionsheet.cancelButtonIndex animated:YES];
    [actionsheet showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        //Delete From Server and CoreData
        NSManagedObjectContext *context = __poi.managedObjectContext;
        
        [context deleteObject:__poi];
        [context save:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}*/
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
        
    }
    
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
