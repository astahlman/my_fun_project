//
//  POICreationModalViewController.h
//  PSIdea
//
//  Created by William Patty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "POI.h"
#import <stdlib.h>
@protocol POICreationModalViewControllerDelegate <NSObject>

@required
-(void) didFinishEditing:(BOOL) finished;
@end

@interface POICreationModalViewController : UIViewController <UITextViewDelegate>{
    NSManagedObjectContext *__managedObjectContext;
}
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet MKMapView *miniMapView;

@property (nonatomic, retain) id <POICreationModalViewControllerDelegate> delegate;
-(id)initWithManagedObjectContext:(NSManagedObjectContext*) context;
@end
