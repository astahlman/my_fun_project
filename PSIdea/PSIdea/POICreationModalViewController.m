//
//  POICreationModalViewController.m
//  PSIdea
//
//  Created by William Patty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "POICreationModalViewController.h"

@implementation POICreationModalViewController
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
    
    // need to pass in user id for user logged in.
    int number = arc4random() % 10000; // This will need to change. Could get same number multiple times
    NSNumber *idNumber = [NSNumber numberWithInt:number];
    [POI createPOIWithID:idNumber andTitle:titleField.text andDetails:detailsField.text andLatitude:nil andLongitude:nil andPhoto:nil andPublic:nil andRating:nil andCreator:nil inManagedObjectContext:__managedObjectContext];
    //Create POI and Save context   
    [delegate didFinishEditing:YES];
}
-(void) cancel{
    [delegate didFinishEditing:NO];
}
-(id)initWithManagedObjectContext:(NSManagedObjectContext*) context{
    self = [super initWithNibName:@"POICreationModalViewController" bundle:[NSBundle mainBundle]];
    if(self){
        __managedObjectContext = context;
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
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Click here to add details."]) {
        textView.text=@"";
    }
}
@end
