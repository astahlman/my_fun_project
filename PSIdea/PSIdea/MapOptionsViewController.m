//
//  MapOptionsViewController.m
//  PSIdea
//
//  Created by William Patty on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MapOptionsViewController.h"

@implementation MapOptionsViewController

@synthesize backgroundPinButtonImage;
@synthesize mapViewType;
@synthesize delegate;
@synthesize backgroundButtonImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (id) initWithPublicSwitchState:(BOOL)isOn{
    self = [super initWithNibName:@"MapOptionsViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
        removePin = [NSNumber numberWithInt:0];
        makePublic = [NSNumber numberWithInt:isOn];


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
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    makePublic = [NSNumber numberWithInt:tableViewCellSwitch.isOn];

    
    NSArray *results = [NSArray arrayWithObjects:makePublic,removePin, nil];
 
    [delegate userDidDismissViewControllerWithResults:results];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mapOptionsBackground"]]];
    [tableViewCellSwitch setOn:[makePublic intValue]];
    backgroundButtonImage.image =[UIImage imageNamed:@"normalPattern1"];
    backgroundButtonImage.layer.cornerRadius = 10.0;
    backgroundButtonImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    backgroundButtonImage.layer.borderWidth = 1.2;
    backgroundButtonImage.layer.masksToBounds = YES;
    backgroundPinButtonImage.image =[UIImage imageNamed:@"normalPattern1"];
    backgroundPinButtonImage.layer.cornerRadius = 10.0;
    backgroundPinButtonImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    backgroundPinButtonImage.layer.borderWidth = 1.2;
    backgroundPinButtonImage.layer.masksToBounds = YES;



    // Do any additional setup after loading the view from its nib.
}


-(IBAction)userDidTouchDownOnButton:(id)sender{
    backgroundPinButtonImage.image =[UIImage imageNamed:@"selectedPattern1"];
    backgroundPinButtonImage.layer.cornerRadius = 10.0;
    backgroundPinButtonImage.layer.borderColor = [UIColor blackColor].CGColor;
    backgroundPinButtonImage.layer.borderWidth = 1.2;
    backgroundPinButtonImage.layer.masksToBounds = YES;
}

- (void)viewDidUnload
{
    customPublicCell = nil;
    tableViewCellSwitch = nil;
    [self setMapViewType:nil];
    [self setBackgroundButtonImage:nil];
    [self setBackgroundPinButtonImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)userDidCancelPress:(id)sender{
    backgroundPinButtonImage.image =[UIImage imageNamed:@"normalPattern1"];
    backgroundPinButtonImage.layer.cornerRadius = 10.0;
    backgroundPinButtonImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    backgroundPinButtonImage.layer.borderWidth = 1.2;
    backgroundPinButtonImage.layer.masksToBounds = YES;
}

-(IBAction)removePinButtonSelected:(id)sender{
    backgroundPinButtonImage.image =[UIImage imageNamed:@"normalPattern1"];
    backgroundPinButtonImage.layer.cornerRadius = 10.0;
    backgroundPinButtonImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    backgroundPinButtonImage.layer.borderWidth = 1.2;
    backgroundPinButtonImage.layer.masksToBounds = YES;
    removePin = [NSNumber numberWithInt:1];
        makePublic = [NSNumber numberWithInt:tableViewCellSwitch.isOn];

    
 
    
    NSArray *results = [NSArray arrayWithObjects:makePublic,removePin, nil];
    
    [delegate userDidDismissViewControllerWithResults:results];
}



@end
