//
//  Photo.h
//  PSIdea
//
//  Created by William Patty on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class POI;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) POI *poi;

@end
