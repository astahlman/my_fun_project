//
//  GridCell.h
//  PSIdea
//
//  Created by Andrew Stahlman on 12/16/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GridCell : NSObject

@property (nonatomic, assign) int rowPos;
@property (nonatomic, assign) int colPos;
@property (nonatomic, retain) UIView* contentItem;

- (id) initWithContentItem:(UIView*)item atRow:(int)row atCol:(int)col;

@end
