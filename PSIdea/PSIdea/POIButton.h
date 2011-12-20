//
//  POIButton.h
//  PSIdea
//
//  Created by Andrew Stahlman on 12/16/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "DraggableButton.h"
#import "POI.h"

@interface POIButton : DraggableButton

@property (nonatomic, retain) POI* poi;

+ (POIButton*)POIButtonWithDelegate:(id<DraggableButtonDelegate>)delegateIn forPOI:(POI*)poiIn;

@end
