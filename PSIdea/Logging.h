//
//  Logging.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/7/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logging : NSObject

+(Logging*)logger;
-(void)logMessage:(NSString*)msg;

@end
