//
//  CoreDataManager.m
//  PSIdea
//
//  Created by Andrew Stahlman on 11/28/11.
//  Copyright (c) 2011 Auburn University. All rights reserved.
//

#import "CoreDataManager.h"
#import "NSManagedObject+PropertiesDict.h"
#import "Logging.h"

@implementation CoreDataManager

+(NSMutableArray*) fetchEntity:(NSString*)entityName fromContext:(NSManagedObjectContext*)context withPredicate:(NSPredicate*)predicate withSortKey:(NSString*)sortKey ascending:(BOOL)isAscending
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    [request setPredicate:predicate];
    if (sortKey != nil)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:isAscending];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
    }
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) 
    {
        // Handle the error.
    }    
    return mutableFetchResults;
}

+(NSDictionary*)primaryKeys
{
    NSMutableDictionary* pk = [[NSMutableDictionary alloc] init];
    [pk setValue:@"twitterHandle" forKey:@"User"];
    [pk setValue:@"idNumber" forKey:@"POI"];
    [pk setValue:@"url" forKey:@"Photo"];
    return (NSDictionary*) pk;
}

+(NSManagedObject*)parseManagedObject:(NSDictionary*)objDict managedObjectContext:(NSManagedObjectContext*)moc
{
    id userPK = [[[self class] primaryKeys] valueForKey:@"User"];
    id poiPK = [[[self class] primaryKeys] valueForKey:@"POI"];
    id photoPK = [[[self class] primaryKeys] valueForKey:@"Photo"];
    NSManagedObject* result;
    if ([objDict valueForKey:userPK] != nil)
    {
        result = [[self class] parseUser:objDict managedObjectContext:moc];
    }
    else if ([objDict valueForKey:poiPK] != nil)
    {
        result = [[self class] parsePOI:objDict managedObjectContext:moc];
    }
    else if ([objDict valueForKey:photoPK] != nil)
    {
        result = [[self class] parsePhoto:objDict managedObjectContext:moc];
    }
    else
    {
        [[Logging logger] logMessage:@"Couldn't parse object as POI, User, or Photo"];
    }
    
    return result;
}

+(POI*)parsePOI:(NSDictionary*)poiDict managedObjectContext:(NSManagedObjectContext*)moc
{    
    NSEntityDescription* desc = [NSEntityDescription entityForName:@"POI" inManagedObjectContext:moc];
    POI* poi = [[POI alloc] initWithEntity:desc insertIntoManagedObjectContext:moc];
    NSMutableDictionary* properties = [[NSMutableDictionary alloc] initWithDictionary:poiDict];
    
    // transfer the keys to the primary keys dictionary
    NSMutableDictionary* primaryKeys = [[NSMutableDictionary alloc] init];
    [primaryKeys setObject:[properties objectForKey:@"creator"] forKey:@"creator"];

    [properties removeObjectForKey:@"creator"];
    [properties removeObjectForKey:@"photo"];
    
    // lat and long are serialized as strings - convert them back to decimal
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* lat = [formatter numberFromString:[properties objectForKey:@"latitude"]];
    NSNumber* lon = [formatter numberFromString:[properties objectForKey:@"longitude"]]; 
    [properties setObject:lat forKey:@"latitude"];
    [properties setObject:lon forKey:@"longitude"];
    
    // convert date string to nsdate
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* creationDate = [df dateFromString:[properties objectForKey:@"creationDate"]];
    [properties setObject:creationDate forKey:@"creationDate"];
    
    // set the poi properties from the dictionary
    for (NSString* key in properties)
    {
        [poi setValue:[properties valueForKey:key] forKey:key];
    }
    
    // fetch the creator
    NSPredicate* creatorPredicate = [NSPredicate predicateWithFormat:@"twitterHandle like %@", [primaryKeys objectForKey:@"creator"]];
    NSArray* creatorResults = [[self class] fetchEntity:@"User" fromContext:moc withPredicate:creatorPredicate withSortKey:nil ascending:YES];
    assert([creatorResults count] <= 1);
    if ([creatorResults count] == 1)
    {
        poi.creator = [creatorResults objectAtIndex:0];
    }
    else
    {
        // TODO: Queue for download from network?
    }
    
    // fetch the photo, if the JSON gives us a URL
    if ([primaryKeys objectForKey:@"photo"] != nil)
    {
        NSPredicate* photoPredicate = [NSPredicate predicateWithFormat:@"url like %@", [primaryKeys objectForKey:@"photo"]];
        NSArray* photoResults = [[self class] fetchEntity:@"Photo" fromContext:moc withPredicate:photoPredicate withSortKey:nil ascending:YES];
        assert([photoResults count] <= 1);
        if ([photoResults count] == 1)
        {
            poi.photo = [photoResults objectAtIndex:0];
        }
        else
        {
            // TODO: Queue for download from network?
        }
    }
    
    return poi;
}

+(User*)parseUser:(NSDictionary*)userDict managedObjectContext:(NSManagedObjectContext*)moc
{
    User* user = [[User alloc] init];
    
    [user setTwitterHandle:[userDict valueForKey:@"twitterHandle"]];
    
    NSArray* pois = [userDict valueForKey:@"pois"];
    NSPredicate* poisPredicate = [NSPredicate predicateWithFormat:@"twitterHandle in %@", pois];
    NSArray* poiResults = [[self class] fetchEntity:@"POI" fromContext:moc withPredicate:poisPredicate withSortKey:nil ascending:YES];
    if ([poiResults count] > 0)
    {
        user.pois = [NSSet setWithArray:poiResults];
    }
    return user;
}

+(Photo*)parsePhoto:(NSDictionary*)photoDict managedObjectContext:(NSManagedObject*)moc
{
    Photo* photo = [[Photo alloc] init];
    
    [photo setUrl:[photoDict valueForKey:@"url"]];
    
    return photo;
}
@end
