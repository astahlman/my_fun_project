//
//  PSINetworkController.h
//  PSIdea
//
//  Created by Andrew Stahlman on 1/23/12.
//  Copyright (c) 2012 Auburn University. All rights reserved.
//

#import "NetworkController.h"
#import "POI.h"


@interface PSINetworkController : NetworkController <NetworkControllerDelegate>

@property (nonatomic, retain) NSURL* baseUrl;

+(PSINetworkController*)PSINetworkControllerWithBaseURL:(NSURL*)baseUrl;
-(void)retrieveObjectForId:(NSString*)idString atRelUrl:(NSString*)relUrl;
-(void)connectionDidFinishLoading:(NSURLConnection*)connection;

+(NSDictionary*)getModelDictionary;
+(NSDictionary*)getPOIMappingDictionary;

-(id)queryForClass:(Class*)queryClass onField:(NSString*)string withString:(NSString*)queryString;
-(void)requestPoi:(NSString*)idString;
-(void)postPoi:(POI*)poi;
-(POI*)parsePoi:(NSDictionary*)poiDict;

@end
