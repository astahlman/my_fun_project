//
//  GridView.h
//  PSIdea
//
//  Created by Andrew Stahlman on 12/16/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCell.h"

@interface GridViewController : UIViewController

@property (nonatomic, retain) NSMutableArray* gridCells;
@property (nonatomic, assign) int numRows;
@property (nonatomic, assign) int numCols;
@property (nonatomic, assign) int cellCount;

- (id)initWithGridItems:(NSMutableArray*)itemsIn numCols:(int)colsIn;
- (id)init;
- (void)addGridCell:(UIView*)item;
- (void)removeGridCellAtRow:(int)row atColumn:(int)col;
- (void)removeGridCellForItem:(UIView*)item;
- (void)resetNumRows:(int)cellCount;
- (void)drawGrid;
- (void)clearGridCells;
- (GridCell*)gridCellForItem:(UIView*)item;

@end
