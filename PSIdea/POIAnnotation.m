//
//  EventAnnotation.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/25/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "POIAnnotation.h"

@implementation POIAnnotation

@synthesize title = __title;
@synthesize details = __details;
@synthesize coordinate = __coordinate;

- (id)initWithDetails:(NSString*)details coordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)title {
    if ((self = [super init])) {
        __details = [details copy];
        __coordinate = coordinate;
        __title = title;
    
    }
    return self;
}

- (NSString*)subtitle {
    return __details;
}

-(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    __coordinate = newCoordinate;
}


-(void) updateAnnotationView:(CLLocation *) location {
    
    CLGeocoder *__coder = [[CLGeocoder alloc] init];
    
    [__coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject];
        self.details = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
}


@end
