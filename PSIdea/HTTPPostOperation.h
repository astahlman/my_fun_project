//
//  HTTPPostOperation.h
//  PSIdea
//
//  Created by Andrew Stahlman on 3/11/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "HTTPOperation.h"

@class HTTPPostOperation;

@protocol HTTPPostOperationDelegate <HTTPOperationDelegate>

-(void)operation:(HTTPPostOperation*)operation didPostAndReceivePrimaryKey:(id)primaryKey;

@end

@interface HTTPPostOperation : HTTPOperation <NSCopying>
{
    NSManagedObject* _postEntity;
}

@property (nonatomic, retain) NSManagedObject* postEntity;
@property (nonatomic, retain) id<HTTPPostOperationDelegate> delegate;

-(id)initWithRequest:(NSURLRequest*)request postEntity:(NSManagedObject*)entity;
-(id)copyWithZone:(NSZone*)zone;

@end
