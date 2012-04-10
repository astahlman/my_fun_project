//
//  MyCLController.m
//  PSIdea
//
//  Created by William Patty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyCLController.h"
@implementation MyCLController

@synthesize locationManager;
@synthesize delegate;

-(id) init{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return self;
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.delegate locationError:error];
}
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if ((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) &&
        (oldLocation.coordinate.longitude != newLocation.coordinate.longitude)){
        [self.delegate locationUpdate:newLocation];

    }
}

 


@end
