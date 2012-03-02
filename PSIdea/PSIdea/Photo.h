//
//  Photo.h
//  PSIdea
//
//  Created by William Patty on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class POI, User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) POI *poi;
@property (nonatomic, retain) User *owner;

@end
