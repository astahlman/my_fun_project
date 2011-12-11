//
//  EventDetailsViewController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "POIDetailsViewController.h"

@implementation POIDetailsViewController

@synthesize titleLabel = __titleLabel;
@synthesize detailsTextView = __detailsTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDetails:(NSString *)details withTitle:(NSString *)title {
    self = [super initWithNibName:@"POIDetailsView" bundle:[NSBundle mainBundle]];
    if (self) {
       __details = details;
        __title = title;
        self.title = title;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailsTextView.text = __details;
    self.titleLabel.text = __title;
    
    containerView.layer.cornerRadius = 10.0;
    containerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    containerView.layer.borderWidth = 1.2;
    containerView.layer.masksToBounds = YES;

}


- (void)viewDidUnload
{
    containerView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
