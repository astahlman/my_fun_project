//
//  ListEditorModalViewController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 12/13/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "ListEditorViewController.h"

@implementation ListEditorViewController
@synthesize searchBar = __searchBar;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize selectedListView = __selectedListView;
@synthesize visiblePoi = __visiblePoi;
@synthesize poiArray = __poiArray;
@synthesize selectedList = __selectedList;
@synthesize listButton = __listButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithContext:(NSManagedObjectContext *)context
{
    self = [super initWithNibName:@"ListEditorViewController" bundle:nil];
    if (self) {
        self.title = @"Edit List";
        __managedObjectContext = context;
        [self setNumCols:3];
        [self fetchTableViewDataInManagedObjectContext:context];
        
        for (POI* poi in __visiblePoi)
        {
            DraggableButton* poiIcon = [POIButton POIButtonWithDelegate:self forPOI:poi];
            [poiIcon setTitle:poi.title forState:UIControlStateNormal];
            [self addGridCell:poiIcon];
        }
        [self drawGrid];
    }
    return self;
}

-(void) fetchTableViewDataInManagedObjectContext: (NSManagedObjectContext*) context{
    __poiArray = [CoreDataManager fetchEntity:@"POI" fromContext:context withPredicate:nil withSortKey:@"title" ascending:YES];
    
    __visiblePoi = [[NSMutableArray alloc] init];
    [__visiblePoi addObjectsFromArray:__poiArray];
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

    __listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    __listButton.titleLabel.text = __selectedList.title;
    [__listButton setFrame:CGRectMake(__selectedListView.bounds.size.width / 2, 0, 50, 75)];
    __listButton.center = CGPointMake(__selectedListView.bounds.size.width / 2, 0);
    [__listButton setBackgroundImage:[UIImage imageNamed:@"notebook_paper.png"] forState:UIControlStateNormal];
    [__listButton setTitle:__selectedList.title forState:UIControlStateNormal];
    __listButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    [__listButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [__selectedListView addSubview:__listButton];
    [self drawGrid];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)buttonReleased:(id)sender withEvent:(UIEvent*)event
{
    CGPoint pointInListView = [[[event allTouches] anyObject] locationInView:__selectedListView];

    if (CGRectContainsPoint(__listButton.frame, pointInListView)) {
        // do nothing yet
        //NSLog(@"Dropped in list.");
        POIButton* button = sender;
        [__selectedList addPoisObject:button.poi];
        [self removeGridCellForItem:button];
        
    }
    else 
    {
        DraggableButton* button = sender;
        button.center = button.dragOrigin;
    }
}

-(void)onVisibleChanged:(NSMutableArray*)visible
{
    [self clearGridCells];
    for (POI* poi in visible) {
        DraggableButton* poiIcon = [POIButton POIButtonWithDelegate:self forPOI:poi];
        [poiIcon setTitle:poi.title forState:UIControlStateNormal];
        [self addGridCell:poiIcon];
    }
    [self drawGrid];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar's cancel button while in edit mode
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [__visiblePoi removeAllObjects];
    [self onVisibleChanged:__visiblePoi];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [__visiblePoi removeAllObjects];
    [__visiblePoi addObjectsFromArray:__poiArray];
    [self onVisibleChanged:__visiblePoi];
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString *)searchText 
{
    NSPredicate *predicate;
    
    if (self.searchBar.text != nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"(title contains[cd] %@) OR (details contains[cd] %@)", self.searchBar.text];
    }
    else {
        predicate = nil;
    }
    
    __visiblePoi = [CoreDataManager fetchEntity:@"POI" fromContext:__managedObjectContext withPredicate:predicate withSortKey:@"title" ascending:YES];
    [self onVisibleChanged:__visiblePoi];
    
}

@end
