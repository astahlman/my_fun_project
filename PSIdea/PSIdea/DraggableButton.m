//
//  DraggableButton.m
//  PSIdea
//
//  Created by Andrew Stahlman on 12/15/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "DraggableButton.h"

@implementation DraggableButton

@synthesize isDraggable = __isDraggable;
@synthesize delegate = __delegate;
@synthesize dragOrigin = __dragOrigin;

-(id)initWithDelegate:(id<DraggableButtonDelegate>)delegateIn
{
    self = [super init];
    if (self)
    {
        __delegate = delegateIn;
        __isDraggable = true;
        [self addTarget:self action:@selector(dragBegan:withEvent:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(buttonMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [self addTarget:__delegate action:@selector(buttonReleased:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}
-(IBAction)dragBegan:(id)sender withEvent:(UIEvent*)event
{
    __dragOrigin = ((DraggableButton*)sender).center;
}
-(IBAction)buttonMoved:(id)sender withEvent:(UIEvent*)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.superview];
    UIControl *control = sender;
    control.center = point;
}

@end
