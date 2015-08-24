//
//  AnimatedTransitioning.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 24.08.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "AnimatedTransitioning.h"

@implementation AnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [fromVC view];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [toVC view];
    
    UIView *containerView = [transitionContext containerView];
    
    BOOL isPresentation = self.isPresentation;
    
    if (isPresentation) {
        [containerView addSubview:toView];
    }
    
    UIViewController *animatingVC = isPresentation ? toVC : fromVC;
    
    UIView *animatingView = [animatingVC view];
    
    CGRect appearedFrame = [transitionContext finalFrameForViewController:animatingVC];
    CGRect dismissedFrame = appearedFrame;
    dismissedFrame.origin.x -= dismissedFrame.size.width;
    CGRect initialFrame = isPresentation ? dismissedFrame : appearedFrame;
    CGRect finalFrame = isPresentation ? appearedFrame : dismissedFrame;
    
    
    
    //    CGRect initialFrame = isPresentation ? appearedFrame : dismissedFrame;
    //    CGRect finalFrame = isPresentation ? dismissedFrame : appearedFrame;
    
    
    
    [animatingView setFrame:initialFrame];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:300.0
          initialSpringVelocity:5.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [animatingView setFrame:finalFrame];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if (![self isPresentation]) {
                             [fromView removeFromSuperview];
                         }
                         
                         [transitionContext completeTransition:YES];
                         
                     }];
    
}

@end

