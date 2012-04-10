//
//  MyCLController.h
//  PSIdea
//
//  Created by William Patty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MyCLControllerDelegate <NSObject>

@required
-(void) locationUpdate:(CLLocation *) location;
-(void) locationError:(NSError*) error;

@end

@interface MyCLController: NSObject <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    id delegate;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) id delegate;

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
@end
