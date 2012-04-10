//
//  GridCell.m
//  PSIdea
//
//  Created by Andrew Stahlman on 12/16/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell

@synthesize rowPos = __rowPos;
@synthesize colPos = __colPos;
@synthesize contentItem = __contentItem;

- (id) initWithContentItem:(UIView*)item atRow:(int)row atCol:(int)col {
    self = [super init];
    if (self)
    {
        __rowPos = row;
        __colPos = col;
        __contentItem = item;
    }
    return self;
}

@end
