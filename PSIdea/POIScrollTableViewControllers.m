//
//  POIScrollTableViewControllers.m
//  PSIdea
//
//  Created by William Patty on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "POIScrollTableViewControllers.h"
#import "AppDelegate.h"
@implementation POIScrollTableViewControllers
@synthesize titleLabel;
@synthesize addPOIButton;
@synthesize poiTableView = _poiTableView;
@synthesize poiArray= __poiArray;
@synthesize visiblePOI = __visiblePOI;
@synthesize index;
@synthesize __containerView;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize delegate;
@synthesize intermediateView = _intermediateView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) fetchTableViewDataInManagedObjectcontext: (NSManagedObjectContext*) context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"list = %@", __list];
    __poiArray = [CoreDataManager fetchEntity:@"POI" fromContext:context withPredicate:predicate withSortKey:@"title" ascending:YES];
    
    __visiblePOI = [[NSMutableArray alloc] init];
    [__visiblePOI addObjectsFromArray:__poiArray];
}

-(void) resetArrays{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idNumber = %@", __list.idNumber];
        NSArray *results = [CoreDataManager fetchEntity:@"List" fromContext:__managedObjectContext withPredicate:predicate withSortKey:@"title" ascending:YES];
    List *list = results.lastObject;
    __list = list;
    __poiArray = [[NSMutableArray alloc] initWithArray:[list.pois allObjects]];
    __visiblePOI = [[NSMutableArray alloc] init];
    [__visiblePOI addObjectsFromArray:__poiArray];
    
}

-(id)initWithList:(List *)list{
    self = [super initWithNibName:@"POIScrollTableViewControllers" bundle:[NSBundle mainBundle]];
    if (self) {
        __list = list;
        __managedObjectContext = list.managedObjectContext;
        __poiArray = [[NSMutableArray alloc] initWithArray:[list.pois allObjects]];
        __visiblePOI = [[NSMutableArray alloc] init];
        [__visiblePOI addObjectsFromArray:__poiArray];
        // perform load of view here
        //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ALL"];
        __title = list.title;
        
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

-(void) longPressedCell:(UIGestureRecognizer*) recognizer{
    
    CGPoint location = [recognizer locationInView:_poiTableView];
    NSIndexPath* indexPath = [_poiTableView indexPathForRowAtPoint:location];
    editRow = indexPath.row;
    //UITableViewCell* cell = [_poiTableView cellForRowAtIndexPath:indexPath];
    [_poiTableView setEditing:YES animated:YES];
    

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text =__title;
    _poiTableView.showsVerticalScrollIndicator = YES;
    _intermediateView.layer.cornerRadius = 10.0;
    _intermediateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _intermediateView.layer.borderWidth = 3.0;
    _intermediateView.layer.masksToBounds = YES;
    editRow = -1;
    lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedCell:)];
    [_poiTableView addGestureRecognizer:lpgr];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [__containerView addGestureRecognizer:tgr];
   // [_poiTableView addGestureRecognizer:tgr];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_poiTableView flashScrollIndicators];
}
- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setAddPOIButton:nil];
    [self setPoiTableView:nil];
    [self setIntermediateView:nil];
    [self set__containerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [__visiblePOI count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    POI *poi = (POI *)[__visiblePOI objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editRow == -1) {
         return NO;
     }
     else if (editRow == indexPath.row) {
         return YES;
     }
     else{
         return NO;
     }
   
 }
 


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSManagedObject *managedObject = [__poiArray objectAtIndex:indexPath.row];
        [__managedObjectContext deleteObject:managedObject];
        [__managedObjectContext save:nil];
        
        [self resetArrays];        
        [tableView setEditing:NO animated:YES];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }    
}

-(void) handleTapGesture:(UIGestureRecognizer*) recognizer{
    if (_poiTableView.isEditing) {
        [_poiTableView setEditing:NO animated:YES];

    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    
    
    // ...
    // Pass the selected object to the new view controller.
    

    POIDetailsViewController *detailViewController = [[POIDetailsViewController alloc]initWithPOI:[__poiArray objectAtIndex:indexPath.row]];
    [delegate pushDetailsView:detailViewController];
    
}   


-(IBAction)createNewPOI:(id) sender{
    
    [delegate createNewPOIForListNumber:__list.idNumber];
    
    
}

-(void) didFinishEditing:(BOOL)finished{
    if (YES) {
        [__managedObjectContext save:nil];
        [self fetchTableViewDataInManagedObjectcontext:__managedObjectContext];
        [self.poiTableView reloadData];
    }
    
    [self.modalViewController dismissModalViewControllerAnimated:YES];
}
-(void) resetViewWithList:(List*)list{
    __title = list.title;
    __list = list;
    titleLabel.text =__title;

}
@end
