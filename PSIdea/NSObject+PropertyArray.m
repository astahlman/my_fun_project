//
//  NSObject+PropertyArray.m
//  PSIdea
//
//  Created by Andrew Stahlman on 1/25/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NSObject+PropertyArray.h"
#import <objc/runtime.h>

@implementation NSObject (PropertyArray)

-(NSArray*) allKeys
{
    u_int count;
    objc_property_t* properties = class_copyPropertyList([self class], &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    return [NSArray arrayWithArray:propertyArray];

    
}

@end
