//
//  DraggableButton.h
//  PSIdea
//
//  Created by Andrew Stahlman on 12/15/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DraggableButtonDelegate

-(IBAction)buttonReleased:(id)sender withEvent:(UIEvent*)event;

@end

@interface DraggableButton : UIButton

@property (nonatomic, assign) Boolean isDraggable;
@property (nonatomic, assign) id<DraggableButtonDelegate> delegate;
@property (nonatomic, assign) CGPoint dragOrigin;

-(id)initWithDelegate:(id<DraggableButtonDelegate>)delegateIn;
-(IBAction)buttonMoved:(id)sender withEvent:(UIEvent*)event;


@end
