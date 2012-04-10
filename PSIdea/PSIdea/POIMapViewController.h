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
#import "POICreationModalViewController.h"
#import "PSINetworkController.h"
#import "NSManagedObject+PropertiesDict.h"
#import "NetworkAPI.h"
#import "Logging.h"
#import "POIDetailsViewController.h"
#import "MyCLController.h"

#define METERS_PER_MILE 1609.344

@interface POIMapViewController : UIViewController <MKMapViewDelegate, ViewWithCoreData, POICreationModalViewControllerDelegate, MyCLControllerDelegate, UISearchBarDelegate>
{
    BOOL centeredAtUserLocation;
    MKCoordinateRegion defaultRegion;
    MyCLController *locationController;
    CLLocation *currentLocation;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet MKMapView *poiMapView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *poiArray;
@property (nonatomic, retain) NSMutableArray *visiblePOI;

-(void)plotPOI;
-(id)initWithContext:(NSManagedObjectContext *)context;
-(void) fetchNearbyPOIForCoordinate:(CLLocationCoordinate2D) coordinate;

-(void) didFinishEditing:(BOOL) finished;

-(void) locationUpdate:(CLLocation *) location;
-(void) locationError:(NSError*) error;
@end
