//
//  PSINetworkController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 1/23/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NetworkController.h"
#import "POI.h"


@interface PSINetworkController : NetworkController

@property (nonatomic, retain) NSURL* baseUrl;

+(PSINetworkController*)PSINetworkControllerWithBaseURL:(NSURL*)baseUrl;
-(void)retrieveObjectForId:(NSString*)idString atRelUrl:(NSString*)relUrl;
-(void)postRequestAtRelUrl:(NSString*)relUrl withPostData:(NSDictionary*)postDict;
-(void)connectionDidFinishLoading:(NSURLConnection*)connection;
-(void)postPoi:(POI*)poi;

@end
