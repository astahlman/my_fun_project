//
//  Logging.m
//  PSIdea
//
//  Created by Andrew Stahlman on 3/7/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "Logging.h"

@implementation Logging

+(Logging*)logger
{
    static Logging* sharedLogger;
    if (sharedLogger == nil)
    {
        @synchronized (self)
        {
            sharedLogger = [[Logging alloc] init];
        }
    }
    return sharedLogger;
}

-(void)logMessage:(NSString*)msg
{
    NSLog(msg);
}

@end
