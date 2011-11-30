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

#define METERS_PER_MILE 1609.344

@interface POIMapViewController : UIViewController <MKMapViewDelegate, ViewWithCoreData>

@property (strong, nonatomic) IBOutlet MKMapView *poiMapView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *poiArray;
@property (nonatomic, retain) NSMutableArray *visiblePOI;

-(void)plotPOI;
-(id)initWithContext:(NSManagedObjectContext *)context;
@end
