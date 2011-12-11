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
    __poiArray = [[NSMutableArray alloc] initWithArray:[__list.pois allObjects]];
    __visiblePOI = [[NSMutableArray alloc] init];
    [__visiblePOI addObjectsFromArray:__poiArray];

}
-(id)initWithContext:(NSManagedObjectContext *)context
{
    self = [super initWithNibName:@"POIScrollTableViewControllers" bundle:[NSBundle mainBundle]];
    if (self) {
        
        __managedObjectContext = context;
        [self fetchTableViewDataInManagedObjectcontext:context];
        // perform load of view here
        //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ALL"];
        self.title = @"Points of Interest";
        
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text =__title;
    _poiTableView.showsVerticalScrollIndicator = YES;
    
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSManagedObject *managedObject = [__poiArray objectAtIndex:indexPath.row];
        [__managedObjectContext deleteObject:managedObject];
        [__managedObjectContext save:nil];
        
        [self fetchTableViewDataInManagedObjectcontext:__managedObjectContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    NSString* details = [[__poiArray objectAtIndex:indexPath.row] details];
    NSString* title = [[__poiArray objectAtIndex:indexPath.row] title];
    POIDetailsViewController *detailViewController = [[POIDetailsViewController alloc] initWithDetails:details withTitle:title];
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

@end
