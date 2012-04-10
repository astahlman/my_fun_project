//
//  GridView.m
//  PSIdea
//
//  Created by Andrew Stahlman on 12/16/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "GridViewController.h"

@implementation GridViewController

@synthesize gridCells = __gridCells;
@synthesize numRows = __numRows;
@synthesize numCols = __numCols;
@synthesize cellCount = __cellCount;

- (id)init
{
    self = [super init];
    if (self) {
        __gridCells = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithGridItems:(NSMutableArray*)itemsIn numCols:(int)colsIn
{
    self = [super init];
    if (self) 
    {
        __gridCells = [[NSMutableArray alloc] init];
        __numCols = colsIn;
        __numRows = (int) ceil(itemsIn.count / __numCols);
        int index = 0;
        for (int i = 0; i < __numRows; i++) {
            
            for (int j = 0; j < __numCols; j++) {
                
                UIView* cellItem = [itemsIn objectAtIndex:index];
                GridCell* cell = [[GridCell alloc] initWithContentItem:cellItem atRow:i atCol:j];
                [__gridCells addObject:cell];
                index++;
            }
        }
    }
    return self;
}

- (void)setGridCells:(NSMutableArray *)gridCells
{
    __gridCells = gridCells;
    for (GridCell* cell in gridCells) 
    {
        [self.view addSubview:cell.contentItem];
    }
}

- (void)addGridCell:(UIView*)item 
{
    int row = __cellCount / __numCols;
    int col = __cellCount % __numCols;
    
    GridCell* cell = [[GridCell alloc] initWithContentItem:item atRow:row atCol:col];
    [__gridCells addObject:cell];
    [self.view addSubview:cell.contentItem];
    __cellCount++;
    [self resetNumRows:__cellCount];
    
}

- (void)clearGridCells
{
    for (GridCell* cell in __gridCells)
    {
        [[cell contentItem] removeFromSuperview];
    }
    [__gridCells removeAllObjects];
    __cellCount = 0;
}

- (void)removeGridCellAtRow:(int)row atColumn:(int)col
{
    int index = (row * __numCols) + col;
    [__gridCells removeObjectAtIndex:index];
    [[[__gridCells objectAtIndex:index] contentItem] removeFromSuperview];
    __cellCount--;
    [self resetNumRows:__cellCount];
}

- (void)removeGridCellForItem:(UIView*)item
{
    GridCell* cell = [self gridCellForItem:item];
    if (cell != nil) 
    {
        [item removeFromSuperview];
        [__gridCells removeObjectIdenticalTo:cell];
        __cellCount--;
        [self resetNumRows:__cellCount];
        [self drawGrid];
    }
    else 
    {
        NSLog(@"ERROR: Tried to remove a non-existent item from the grid.");
    }

}

- (GridCell*)gridCellForItem:(UIView*)item
{
    for (GridCell* cell in __gridCells) {
        if (cell.contentItem == item) {
            return cell;
        }
    }
    
    return nil;
}

- (void)resetNumRows:(int)cellCount 
{
    double rows = (double)cellCount / __numCols;
    __numRows = ceil(rows);
}

- (void)drawGrid;
{
    int index = 0;
    for (int i = 0; i < __numRows; i++) {
        for (int j = 0; j < __numCols; j++) {
            if (index < __cellCount) {
                UIView* cellItem = [[__gridCells objectAtIndex:index] contentItem];
                int x = (self.view.bounds.size.width / (__numCols + 1)) * (j + 1);
                // TODO: change 3 to a constant in a Constants header file
                int y = (i + 1) * (cellItem.bounds.size.height + 3);
                //x += __gridOrigin.x;
                //y += __gridOrigin.y;
                cellItem.center = CGPointMake(x, y);
                index++;
            }
        }
    }
    for (UIView* view in self.view.subviews) {
        NSLog(@"Subview: %@", view);
    }
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
    for (GridCell* cell in __gridCells) {
        [self.view addSubview:cell.contentItem];
    }
}


- (void)viewDidUnload
{
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
