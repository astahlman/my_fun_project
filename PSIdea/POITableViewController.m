//
//  EventTableViewController.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "POITableViewController.h"

@implementation POITableViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize poiTableView = __poiTableView;
@synthesize poiArray = __poiArray;
@synthesize visiblePOI = __visiblePOI;
@synthesize searchBar = __searchBar;
@synthesize index;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) fetchTableViewDataInManagedObjectcontext: (NSManagedObjectContext*) context{
    __poiArray = [CoreDataManager fetchEntity:@"POI" fromContext:context withPredicate:nil withSortKey:@"title" ascending:YES];
    
    __visiblePOI = [[NSMutableArray alloc] init];
    [__visiblePOI addObjectsFromArray:__poiArray];
}
-(id)initWithContext:(NSManagedObjectContext *)context
{
    self = [super initWithNibName:@"POITableView" bundle:nil];
    if (self) {
        
    __managedObjectContext = context;
        [self fetchTableViewDataInManagedObjectcontext:context];
    // perform load of view here
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ALL"];
        self.title = @"Points of Interest";
        
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setPoiTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) createNewPOI{
    POICreationModalViewController *poiCreationMVC = [[POICreationModalViewController alloc] initWithManagedObjectContext:__managedObjectContext];
    poiCreationMVC.delegate = self;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:poiCreationMVC];
    [self presentModalViewController:navCon animated:YES];
    
}

-(void) didFinishEditing:(BOOL)finished{
    if (YES) {
        [__managedObjectContext save:nil];
        [self fetchTableViewDataInManagedObjectcontext:__managedObjectContext];
        [self.tableView reloadData];
    }
    
    [self.modalViewController dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewPOI)];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar's cancel button while in edit mode
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // flush the previous search content
    [__visiblePOI removeAllObjects];
    [__poiTableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [__visiblePOI removeAllObjects];
    [__visiblePOI addObjectsFromArray:__poiArray];
    [__poiTableView reloadData];
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
        // TODO: search tags, not details
        predicate = [NSPredicate predicateWithFormat:@"(title contains[cd] %@) OR (details contains[cd] %@)", self.searchBar.text, self.searchBar.text];
    }
    else {
        predicate = nil;
    }
    
    __visiblePOI = [CoreDataManager fetchEntity:@"POI" fromContext:__managedObjectContext withPredicate:predicate withSortKey:@"title" ascending:YES];
    [__poiTableView reloadData];
    
}

@end
