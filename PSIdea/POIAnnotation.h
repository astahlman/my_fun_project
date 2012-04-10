//
//  EventAnnotation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/25/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface POIAnnotation : NSObject <MKAnnotation>

@property (copy) NSString* details;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) int tag;

// Instance methods

- (id)initWithDetails:(NSString*)details coordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title;
-(void) updateAnnotationView:(CLLocation *) location;

@end
