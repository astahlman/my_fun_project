//
//  EventAnnotation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 11/25/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface POIAnnotation : NSObject <MKAnnotation>

@property (copy) NSString* details;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithDetails:(NSString*)details coordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title;

@end
