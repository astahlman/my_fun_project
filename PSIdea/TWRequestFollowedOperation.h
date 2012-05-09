//
//  TWRequestFollowedOperation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 4/11/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "TWRequestOperation.h"

@interface TWRequestFollowedOperation : TWRequestOperation
{
    NSArray* _followed;
}

@property (nonatomic, retain) NSArray* followed;

@end
