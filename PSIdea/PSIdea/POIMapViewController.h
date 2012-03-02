//
//  EventMapViewController2.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/25/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "POIAnnotation.h"
#import "POI.h"
#import "ViewWithCoreData.h"
#import "CoreDataManager.h"
#import "MyCLController.h"


#define METERS_PER_MILE 1609.344

@interface POIMapViewController : UIViewController <MKMapViewDelegate, ViewWithCoreData,MyCLControllerDelegate>
{
    BOOL nearby;
    BOOL centeredAtUserLocation;
    MKCoordinateRegion defaultRegion;
    MYCLController *locationController;
    CLLocation *currentLocation;
}

@property (strong, nonatomic) IBOutlet MKMapView *poiMapView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *poiArray;
@property (nonatomic, retain) NSMutableArray *visiblePOI;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentSelected:(id)sender;
-(void)plotPOI;
-(id)initWithContext:(NSManagedObjectContext *)context;
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end
