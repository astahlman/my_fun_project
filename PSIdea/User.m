//
//  User.m
//  PSIdea
//
//  Created by William Patty on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "POI.h"


@implementation User

@dynamic twitterHandle;
@dynamic pois;


//creates new user managed object (if it doesn't already exist)


+(User*) createUserWithHandle:(NSString*) twitterHandle andPOIs: (NSArray*) pois inManagedObjectContext:(NSManagedObjectContext*) context
{

    User *user = nil;
    // TODO: We'll eventually want to disallow POI's without a creator
    // For now we can allow it for testing purposes
    if (twitterHandle == nil)
    {
        twitterHandle = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterHandle"];
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    request.entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"twitterHandle = %@", twitterHandle];

    NSError *error = nil;

    user = [[context executeFetchRequest:request error:&error] lastObject];

    if(!user && !error){
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.twitterHandle = twitterHandle;  
        // TODO: You can't create POI's without a creator, so you can't assign existing POI's
        // to a new creator. Eliminate the andPOIs: argument.
        // This is here becaue if we want to store user information in CoreData. Those users do
        // have POI. -will
        for(int i=0; i<pois.count; i++)
        {
            [POI createPOIWithID:[pois objectAtIndex:i] andTitle:nil andDetails:nil andLatitude:nil andLongitude:nil andPhoto:nil  andRating:nil andCreator:twitterHandle inManagedObjectContext:context];       
        }
    
    }

    return user;
}


/* 
 * Method for getting user's twitter username and profile picture
 */


+(void) setUpCurrentUser {
    
        
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                [[NSUserDefaults standardUserDefaults] setValue:twitterAccount.username forKey:@"twitterHandle"];
                NSURL *url =
                [NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:twitterAccount.username forKey:@"screen_name"];
                [params setObject:@"bigger" forKey:@"size"];
                
                TWRequest *request = [[TWRequest alloc] initWithURL:url
                                                         parameters:params
                                                      requestMethod:TWRequestMethodGET];
                
                [request performRequestWithHandler:
                 ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     if (responseData) {
                         NSDictionary *user =
                         [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:NSJSONReadingAllowFragments
                                                           error:NULL];
                         
                         NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
                         
                         //  As an example we could set an image's content to the image
                         dispatch_async
                         (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                             NSData *imageData =
                             [NSData dataWithContentsOfURL:
                              [NSURL URLWithString:profileImageUrl]];
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [[NSUserDefaults standardUserDefaults] setValue:imageData forKey:@"userPhoto"];

                             });
                         });
                     }
                 }];                
            }
        }
    }];
    
}


@end
