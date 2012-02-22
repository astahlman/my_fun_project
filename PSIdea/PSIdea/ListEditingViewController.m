//
//  ListEditingViewController.m
//  PSIdea
//
//  Created by William Patty on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListEditingViewController.h"



@implementation ListEditingViewController
@synthesize intermediateView;
@synthesize searchBar;
@synthesize __tableView;
@synthesize containerView;
@synthesize delegate;
@synthesize customCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) fetchTableViewDataInManagedObjectcontext: (NSManagedObjectContext*) context{
    listArray = [CoreDataManager fetchEntity:@"List" fromContext:context withPredicate:nil withSortKey:@"idNumber" ascending:YES];
    
    visibleList = [[NSMutableArray alloc] init];
    List *list;
    for (int i = 0; i<listArray.count; i++) {
        
        list = [listArray objectAtIndex:i];
        [visibleList addObject:list.title];
    }
}

-(void) resetListArray{
    listArray = [CoreDataManager fetchEntity:@"List" fromContext:__managedObjectContext withPredicate:nil withSortKey:@"idNumber" ascending:YES];
}

-(id)initWithContext:(NSManagedObjectContext *)context
{
    self = [super initWithNibName:@"ListEditingViewController" bundle:nil];
    if (self) {
        
        __managedObjectContext = context;
        [self fetchTableViewDataInManagedObjectcontext:context];
        self.parentViewController.title = @"Lists";
        
    }
    return self;
}

-(void) createNewListForTitle:(NSString*)title{
 
    [List createtListWithTitle:title withIDNumber:[NSNumber numberWithInt:visibleList.count-1]InManagedObjectContext:__managedObjectContext];
    [__managedObjectContext save:nil];
    [self resetListArray];
}

-(void) viewWillDisappear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) done{
    [self.slideNavigationViewController slideForViewController:nil
                                                     direction:MWFSlideDirectionNone
                                   portraitOrientationDistance:0
                                  landscapeOrientationDistance:0];
}

-(void) reload{
    [self.__tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [__tableView setEditing:editing animated:YES];

    if (editing) {
        // Execute tasks for editing status
        self.parentViewController.navigationItem.leftBarButtonItem = nil;
        [visibleList addObject:@"Create New List..."]; 
        NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:visibleList.count-1 inSection:0]];
        [__tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
        
    } else {
        // Execute tasks for non-editing status.
        self.parentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        
        if(newListField.text.length<=0){
            
            [visibleList removeLastObject];
            
            
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:visibleList.count inSection:0]];
            
            [__tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
        }
        else{
            [visibleList replaceObjectAtIndex:visibleList.count-1 withObject:newListField.text];
            [self createNewListForTitle:newListField.text];

        }
        
        activeField.enabled = NO;
        newListField.enabled = NO;
        [self performSelector:@selector(reload)withObject:nil afterDelay:0.3];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(self.parentViewController.navigationItem.leftBarButtonItem !=nil){
        self.parentViewController.navigationItem.leftBarButtonItem = nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
    keyboardIsShown = NO;
   

}

-(void) viewWillAppear:(BOOL)animated{
    self.parentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.parentViewController.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidUnload
{
    [self setIntermediateView:nil];
    [self setSearchBar:nil];
    [self set__tableView:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self setCustomCell:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardDidShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil];  
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

   
    return [visibleList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"ListCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ListEditingTableViewCell" owner:self options:nil];
            cell = customCell;
            cell.showsReorderControl = YES;
            self.customCell = nil;
        }    
        
        UITextField *field;
        field = (UITextField*) [cell viewWithTag:1];
    if (indexPath.row == visibleList.count-1) {
        if(tableView.isEditing){
            newListField = field;
        }
    }
        field.enabled = tableView.isEditing;
    field.text = [visibleList objectAtIndex:indexPath.row];
    if (tableView.isEditing) {
        if ([field.text isEqualToString:@"Create New List..."]) {
            field.text =@"";
            field.placeholder = @"Create New List...";
        }    

    }
       
        return cell;


         
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    UITextField *field = (UITextField*)[cell viewWithTag:1];
    field.enabled = YES;
    
    return UITableViewCellEditingStyleDelete;
}

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
     
     if (indexPath.row == 0 || indexPath.row == visibleList.count-1) {
         return NO;
     }
     else{
         return YES;
     }
 }



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
       [visibleList removeObjectAtIndex:indexPath.row];
        NSManagedObject *managedObject = [listArray objectAtIndex:indexPath.row];
        [__managedObjectContext deleteObject:managedObject];
        [__managedObjectContext save:nil];
        
        [self resetListArray];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } 
}



 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     NSString *title = [visibleList objectAtIndex:fromIndexPath.row];
   List *movedList = [listArray objectAtIndex:fromIndexPath.row];
     movedList.idNumber = [NSNumber numberWithInt:toIndexPath.row];
     [listArray removeObjectAtIndex:fromIndexPath.row];
     [visibleList removeObjectAtIndex:fromIndexPath.row];
     [listArray insertObject:movedList atIndex:toIndexPath.row];
     [visibleList insertObject:title atIndex:toIndexPath.row];
     [__managedObjectContext save:nil];
 }
 
- (NSIndexPath *) tableView: (UITableView *) tableView
targetIndexPathForMoveFromRowAtIndexPath: (NSIndexPath *) source
        toProposedIndexPath: (NSIndexPath *) destination {
    
    if (destination.row > 0 && destination.row < visibleList.count - 2) {
        return destination;
    }
    
    NSIndexPath *indexPath = nil;
    
    if (destination.row == 0) {
        indexPath = [NSIndexPath indexPathForRow: 1  inSection: 0];
    } else {
        indexPath = [NSIndexPath indexPathForRow: visibleList.count-2
                                       inSection: 0];
    }
    
    return indexPath;
    
} 
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
     if (indexPath.row == 0 || indexPath.row == visibleList.count-1) {
         return NO;
     }

 return YES;
 }
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.    
    // ...
    // Pass the selected object to the new view controller.
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITextField *field = (UITextField*)[cell viewWithTag:1];
    field.textColor = [UIColor whiteColor];
    
    [delegate didSelectRow:indexPath.row];
    [self done];

}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    activeField.tag = [visibleList indexOfObject:textField.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:newListField]) {
        newListField.placeholder = @"";
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:newListField]) {
        newListField.placeholder = @"";
        [visibleList replaceObjectAtIndex:visibleList.count-1 withObject:newListField.text];
        [self createNewListForTitle:newListField.text];
        
        [visibleList addObject:@"Create New List..."]; 
        NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:visibleList.count-1 inSection:0]];
        [__tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];

    }
    
    else{
        
        [visibleList replaceObjectAtIndex:textField.tag withObject:textField.text];
        List *list = [listArray objectAtIndex:textField.tag];
        list.title = textField.text;
        [__managedObjectContext save:nil];     }
    
    [textField resignFirstResponder];
    return YES;


}


- (void)keyboardWillHide:(NSNotification *)n
{

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    __tableView.contentInset = contentInsets;
    __tableView.scrollIndicatorInsets = contentInsets;

    keyboardIsShown = NO;



}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height-54, 0.0);
    __tableView.contentInset = contentInsets;
    __tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardFrame.size.height;
    CGPoint point = CGPointMake(activeField.frame.origin.x,  activeField.frame.size.height-activeField.frame.origin.y);
    CGPoint currentFrame = [activeField convertPoint: point toView:self.view];
    if (!CGRectContainsPoint(aRect, currentFrame) ) { 
        CGPoint scrollPoint = CGPointMake(0.0, currentFrame.y-186);
        [__tableView setContentOffset:scrollPoint animated:YES];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    keyboardIsShown = YES;
    [UIView commitAnimations];
    }
@end

