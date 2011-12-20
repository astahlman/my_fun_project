//
//  POIButton.m
//  PSIdea
//
//  Created by Andrew Stahlman on 12/16/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "POIButton.h"

@implementation POIButton

@synthesize poi = __poi;

+ (POIButton*)POIButtonWithDelegate:(id<DraggableButtonDelegate>)delegateIn forPOI:(POI*)poiIn
{
    POIButton* poiIcon = [[POIButton alloc] initWithDelegate:delegateIn];
    poiIcon.poi = poiIn;
    [poiIcon setBounds:CGRectMake(0, 0, 50, 50)];
    [poiIcon setBackgroundImage:[UIImage imageNamed:@"marker_pin.png"] forState:UIControlStateNormal];
    poiIcon.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    [poiIcon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return poiIcon;
}

@end
