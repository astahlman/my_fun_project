//
//  EventMapViewController2.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/25/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "EventAnnotation.h"
#import "Event.h"

#define METERS_PER_MILE 1609.344

@interface EventMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *eventMapView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *eventsArray;

-(void)plotEvents;
-(void)loadEventsFromContext:(NSManagedObjectContext*)moc;

@end
