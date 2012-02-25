//
//  MWFSlideNavigationViewController.h
//
//  Created by Meiwin Fu on 24/1/12.
//  Copyright (c) Meiwin Fu (blockthirty). All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>

/** @enum Slide direction available when performing slide navigation. */
typedef enum {
    /** When secondary view controller is presented, it slides primary view controller back that conceals the secondar view controller. */
    MWFSlideDirectionNone,
    /** It slides primary view controller in up/north direction, resulting in view of secondary view controller provided is being revealed. */
    MWFSlideDirectionUp,
    /** It slides primary view controller in left/west direction, resulting in view of secondary view controller provided is being revealed. */
    MWFSlideDirectionLeft,
    /** It slides primary view controller in down/south direction, resulting in view of secondary view controller provided is being revealed. */
    MWFSlideDirectionDown,
    /** It slides primary view controller in right/east direction, resulting in view of secondary view controller provided is being revealed. */
    MWFSlideDirectionRight
} MWFSlideDirection;

@class MWFSlideNavigationViewController;

#pragma mark - 
/** The `MWFSlideNavigationViewControllerDelegate` protocol defines methods a slide navigation controller delegate can implement to change the behavior when sliding animation is performed.
 */
@protocol MWFSlideNavigationViewControllerDelegate 
@optional
/** @name Customizing behavior */

/** Sent to receiver before sliding animation is performed.
 *
 * @param controller The slide navigation view controller.
 * @param targetController The secondary view controller to be revealed/concealed by the animation.
 * @param slideDirection The animation's slide direction.
 * @param distance The slide distance.
 * @param orientation The current interface orientation.
 */
- (void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller 
                   willPerformSlideFor:(UIViewController *)targetController 
                    withSlideDirection:(MWFSlideDirection)slideDirection
                              distance:(CGFloat)distance
                           orientation:(UIInterfaceOrientation)orientation;

/** Sent to receiver after sliding animation is completed.
 *
 * @param controller The slide navigation view controller.
 * @param targetController The secondary view controller that was revealed/concealed by the animation.
 * @param slideDirection The animation's slide direction.
 * @param distance The slide distance.
 * @param orientation The current interface orientation.
 */
- (void) slideNavigationViewController:(MWFSlideNavigationViewController *)controller 
                    didPerformSlideFor:(UIViewController *)targetController 
                    withSlideDirection:(MWFSlideDirection)slideDirection
                              distance:(CGFloat)distance
                           orientation:(UIInterfaceOrientation)orientation;

@end

#pragma mark - 
/** The `MWFSlideNavigationViewController` is a container view controller implementation
 * that manages a primary and secondary view controller.
 *
 * Primary view controller is basically the root view controller provided during the class 
 * initialization using [MWFSlideNavigationViewController initWithRootViewController:] method. 
 * The primary/root view fills the whole of `MWFSlideNavigationViewController` view area.
 *
 * Secondary view controller is the 'hidden' beneath the primary/root view.
 * It is revealed by sliding the primary/root view in one of the 4 directions supported (`MWFSlideDirectionUp`, `MWFSlideDirectionLeft`, `MWFSlideDirectionDown` or `MWFSlideDirectionRight`),
 * using [MWFSlideNavigationViewController slideForViewController:direction:portraitOrientationDistance:landscapeOrientationDistance:] method.
 * The same method is used to slide the primary/root view back, by specifying `MWFSlideDirectionNone` as the slide direction.
 *
 * This view controller notifies its delegate in response to the sliding event. The delegate is a custom object
 * provided by your application that conforms to the MWFSlideNavigationViewControllerDelegate protocol. You can use
 * the callback methods to perform additional setup or cleanup tasks.
 *
 * @warning *Important:* When not showing, secondary view controller is removed from slide navigation controller and not retained.
 * It's the responsibilty of application to retain it if needed.
 *
 */
@interface MWFSlideNavigationViewController : UIViewController {
    UIViewController * _secondaryViewController;
}
/** The receiver's delegate or `nil` if it doesn't have a delegate. */
@property (nonatomic, weak) id<MWFSlideNavigationViewControllerDelegate> delegate;
/** The root view controller. */
@property (nonatomic, strong) UIViewController * rootViewController;
/** The current slide direction. */
@property (nonatomic, readonly) MWFSlideDirection currentSlideDirection;
/** The current portrait orientation slide distance. */
@property (nonatomic, readonly) NSInteger currentPortraitOrientationDistance;
/** The current landscape orientation slide distance. */
@property (nonatomic, readonly) NSInteger currentLandscapeOrientationDistance;

/* @name Creating slide navigation view controller */

/** Initializes and returns a newly created slide navigation view controller.
 *
 * Even it's not mandatory, each slide navigation controller should have a root view controller as its primary view controller.
 *
 * @param rootViewController The primary view controller
 * @return The initialized slide navigation view controller or `nil` if there was problem initializing the object.
 */
- (id) initWithRootViewController:(UIViewController *)rootViewController;

/* @name Sliding view controller */

/** Perform slide animation that reveals/hides the specified `viewController`. If the direction is `MWFSlideDirectionNone`, the values provided for `viewController` and distances are ignored, it's advised to just specify nil for `viewController` and 0 for distances.
 *
 * @param viewController The secondary view controller or `nil` if direction is `MWFSlideDirectionNone`.
 * @param direction The slide direction: `MWFSlideDirectionUp`, `MWFSlideDirectionLeft`, `MWFSlideDirectionDown`, `MWFSlideDirectionRight` or `MWFSlideDirectionNone`.
 * @param portraitOrientationDistance The distance of slide when in portrait orientation.
 * @param landscapeOrientationDistance The distance of slide when in landscape orientation.
 */
- (void) slideForViewController:(UIViewController *)viewController 
                      direction:(MWFSlideDirection)direction 
    portraitOrientationDistance:(CGFloat)portraitOrientationDistance
   landscapeOrientationDistance:(CGFloat)landscapeOrientationDistance;

@end

#pragma mark - 
/** The MWFSlideNavigationViewController Additions for UIViewController
 * 
 * The MWFSlideNavigationViewController adds convenience method to access the container slide navigation view controller if
 * the receiver is contained in one.
 */
@interface UIViewController (MWFSlideNavigationViewController)
/** @name Getting container slide navigation controller */

/** Get the current container slide navigation controller of the receiver. 
 * 
 * @return The container slide navigation view controller or `nil` if the receiver is not contained in one.
 */
- (MWFSlideNavigationViewController *) slideNavigationViewController;

@end
