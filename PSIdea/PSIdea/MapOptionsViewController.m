//
//  MapOptionsViewController.m
//  PSIdea
//
//  Created by William Patty on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MapOptionsViewController.h"

@implementation MapOptionsViewController

@synthesize mapViewType;
@synthesize groupedTableView;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (id) initWithPublicSwitchState:(BOOL)isOn andMapType:(int)mapType{
    self = [super initWithNibName:@"MapOptionsViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
        mapViewOption =[NSNumber numberWithInt:mapType];
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

    
    NSArray *results = [NSArray arrayWithObjects:makePublic,removePin,mapViewOption, nil];
 
    [delegate userDidDismissViewControllerWithResults:results];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mapViewType.selectedSegmentIndex =     [mapViewOption intValue];


    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    customPublicCell = nil;
    [self setGroupedTableView:nil];
    tableViewCellSwitch = nil;
    [self setMapViewType:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Public";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = customPublicCell;
        if([makePublic intValue] == 1){
            [tableViewCellSwitch setOn:YES animated:YES];
            
        }
    }

    return cell;
}

-(IBAction)removePinButtonSelected:(id)sender{
    removePin = [NSNumber numberWithInt:1];
        makePublic = [NSNumber numberWithInt:tableViewCellSwitch.isOn];

    
    mapViewOption = [NSNumber numberWithInt:[mapViewType selectedSegmentIndex]];
    
    NSArray *results = [NSArray arrayWithObjects:makePublic,removePin,mapViewOption, nil];
    
    [delegate userDidDismissViewControllerWithResults:results];
}

- (IBAction)mapTypeSlected:(id)sender {
    makePublic = [NSNumber numberWithInt:tableViewCellSwitch.isOn];

    mapViewOption = [NSNumber numberWithInt:[mapViewType selectedSegmentIndex]];
    NSArray *results = [NSArray arrayWithObjects:makePublic,removePin,mapViewOption, nil];
    
    [delegate userDidDismissViewControllerWithResults:results];
}


@end
