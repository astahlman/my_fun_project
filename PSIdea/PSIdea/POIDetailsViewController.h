//
//  EventDetailsViewController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/22/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface POIDetailsViewController : UIViewController{
    NSString *__title;
    NSString *__details;
    __weak IBOutlet UIView *containerView;
}

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UITextView* detailsTextView;

- (id)initWithDetails:(NSString *)details withTitle:(NSString *)title;

@end
