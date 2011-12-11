//
//  ListsScrollViewController.h
//  PSIdea
//
//  Created by William Patty on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewWithCoreData.h"
#import "List.h"
#import "CoreDataManager.h"
#import "POIScrollTableViewControllers.h"
#import <QuartzCore/QuartzCore.h>
#import "POICreationModalViewController.h"

@interface ListsScrollViewController : UIViewController <UIScrollViewDelegate,POICreationModalViewControllerDelegate,POIScrollTableViewControllersDelegate>
{
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    
    NSMutableArray *__listArray;
    
    int currentIndex;
    int firstVisiblePageIndexBeforeScroll;
    CGFloat percentScrolledIntoFirstVisiblePage;
    
    NSManagedObjectContext *__managedObjectContext;
    
    POIScrollTableViewControllers *currentPage;

}
@property (weak, nonatomic) IBOutlet UIScrollView *pagingScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

-(void) pushDetailsView:(POIDetailsViewController *)detailsVC;
-(void)didFinishEditing:(BOOL)finished;
-(void)createNewPOIForListNumber:(NSNumber *)listNumber;

-(IBAction)pageChanged:(id)sender;
-(id)initWithContext:(NSManagedObjectContext*) context;

- (void)configurePage:(POIScrollTableViewControllers *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (void)tilePages;
- (POIScrollTableViewControllers *)dequeueRecycledPage;
- (NSUInteger)tableCount;
@end
