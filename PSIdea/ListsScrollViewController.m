//
//  ListsScrollViewController.m
//  PSIdea
//
//  Created by William Patty on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ListsScrollViewController.h"

@implementation ListsScrollViewController
@synthesize pagingScrollView;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) configurePagingScrollView{
    
    
    pagingScrollView.frame = [self frameForPagingScrollView];
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.backgroundColor = [UIColor clearColor];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.directionalLockEnabled = YES;
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    pagingScrollView.alwaysBounceVertical = NO;
    pagingScrollView.clipsToBounds = YES;
    pagingScrollView.delegate = self;
    
}

-(void) fetchCoreDataEntitiesInManagedObjectContext: (NSManagedObjectContext*) context{
    __listArray = [CoreDataManager fetchEntity:@"List" fromContext:context withPredicate:nil withSortKey:@"idNumber" ascending:YES];
}

-(id) initWithContext:(NSManagedObjectContext *)context{
    self = [super initWithNibName:@"ListsScrollViewController" bundle:[NSBundle mainBundle]];
    if(self){
        __managedObjectContext = context;
        [self fetchCoreDataEntitiesInManagedObjectContext:context];
        self.parentViewController.title = @"Lists";
    }
    
    return self;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [currentPage resetArrays];
    [self tilePages];
    [currentPage.poiTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) editList{
    
    ListEditingViewController *levc = [[ListEditingViewController alloc] initWithContext:__managedObjectContext];
    levc.delegate = self;
    
    [self.slideNavigationViewController slideForViewController:levc direction:MWFSlideDirectionDown portraitOrientationDistance:420 landscapeOrientationDistance:320];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.parentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editList)];
    // Do any additional setup after loading the view from its nib.
    pageControl.numberOfPages = [__listArray count];
    pageControl.currentPage = 0;
    [self configurePagingScrollView];
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages = [[NSMutableSet alloc] init];
}


- (void)viewDidUnload
{
    [self setPagingScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) tilePages{
    
    CGRect visibleBounds = pagingScrollView.bounds;
    
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self tableCount] - 1);
    
    for(POIScrollTableViewControllers *page in visiblePages){
        if(page.index <firstNeededPageIndex || page.index > lastNeededPageIndex){
            [recycledPages addObject:page];
            [page.view removeFromSuperview];
        }
    }
    
    [visiblePages minusSet:recycledPages];
    
    for(int index = firstNeededPageIndex; index<=lastNeededPageIndex; index++){
        if(![self isDisplayingPageForIndex:index]){
            POIScrollTableViewControllers *page = [self dequeueRecycledPage];
            if(!page){
                page = [[POIScrollTableViewControllers alloc] initWithList:[__listArray objectAtIndex:index]];
                
            }
            
            [self configurePage:page forIndex:index];
            currentPage = page;
            [pagingScrollView addSubview:page.view];
            [visiblePages addObject:page];
        }
    }
}

- (POIScrollTableViewControllers *) dequeueRecycledPage{
    POIScrollTableViewControllers *page = [recycledPages anyObject];
    if(page){
        [recycledPages removeObject:page];
    }
    return page;
}

-(BOOL) isDisplayingPageForIndex:(NSUInteger)index{
    BOOL foundPage = NO;
    
    for  ( POIScrollTableViewControllers *page in visiblePages){
        if(page.index == index){
            foundPage = YES;
            break;
        }
    }
    
    return foundPage;
}


-(void) configurePage:(POIScrollTableViewControllers *)page forIndex:(NSUInteger)index{
    [page resetViewWithList:[__listArray objectAtIndex:index]];
    page.index = index;
    page.view.frame = [self frameForPageAtIndex:index];
    page.view.layer.cornerRadius = 10.0;
    page.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
    page.view.layer.borderWidth = 1.2;
    page.view.layer.masksToBounds = YES;
    page.delegate = self;
    [page resetArrays];
    [page.poiTableView reloadData];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self tilePages];
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        currentIndex = page;
        for(POIScrollTableViewControllers *page in visiblePages) {
            if (page.index == currentIndex) {
                
                currentPage = page;
                pageControl.currentPage = currentIndex;
                previousPage = currentIndex;
            }
        }
        
    }  
    
    
}
#define PADDING  10

-(CGRect) frameForPagingScrollView{
    CGRect frame = CGRectMake(10, 20, 300, 420);
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

-(CGRect) frameForPageAtIndex:(NSUInteger)index{
    CGRect bounds = pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {

    CGRect bounds = pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self tableCount], bounds.size.height - 108);
}


-(NSUInteger)tableCount{
    return [__listArray count];
}

-(IBAction)pageChanged:(id)sender{
    currentIndex = pageControl.currentPage;
    [pagingScrollView setContentOffset:CGPointMake(pagingScrollView.bounds.size.width *currentIndex,0.0f) animated:YES];
}

-(void) createNewPOIForListNumber:(NSNumber *)listNumber{
    
    POICreationModalViewController *poiCreationMVC = [[POICreationModalViewController alloc] initWithManagedObjectContext:__managedObjectContext];
    poiCreationMVC.delegate = self;
    poiCreationMVC.listNumber = listNumber;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:poiCreationMVC];
    [self presentModalViewController:navCon animated:YES];
}

-(void) didFinishEditing:(BOOL)finished {
    if (YES) {
        [__managedObjectContext save:nil];
        
    }
    
    [self fetchCoreDataEntitiesInManagedObjectContext:__managedObjectContext];
    [self configurePage:currentPage forIndex:currentIndex];
  //  [currentPage resetArrays];
    [self tilePages];
   // [currentPage.poiTableView reloadData];
    [self.modalViewController dismissModalViewControllerAnimated:YES];
}

-(void) pushDetailsView:(POIDetailsViewController *)detailsVC{
    [self.navigationController pushViewController:detailsVC animated:YES];
}

-(void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller willPerformSlideFor:(UIViewController *)targetController withSlideDirection:(MWFSlideDirection)slideDirection distance:(CGFloat)distance orientation:(UIInterfaceOrientation)orientation{
    if (slideDirection == MWFSlideDirectionDown) {

    }
    
    else {
        self.parentViewController.navigationItem.rightBarButtonItem = nil;

        self.parentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editList)];   
        
            
        [self fetchCoreDataEntitiesInManagedObjectContext:__managedObjectContext];
        if (currentIndex > __listArray.count-1) {
            currentIndex = __listArray.count-1;
        }
        [self configurePage:currentPage forIndex:currentIndex];

        pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
        pageControl.numberOfPages = [__listArray count];
        [self tilePages];
    }
}

-(void) didSelectRow:(NSUInteger)row{
    currentIndex = row;
    pageControl.currentPage = currentIndex;
 [pagingScrollView setContentOffset:CGPointMake(pagingScrollView.bounds.size.width *currentIndex,0.0f) animated:NO];

}
@end
