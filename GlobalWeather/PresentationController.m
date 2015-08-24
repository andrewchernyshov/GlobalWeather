//
//  PresentationController.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 24.08.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "PresentationController.h"

@implementation PresentationController

- (instancetype) initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        [self prepareDimmingView];
    }
    return self;
}


- (void) prepareDimmingView
{
    self.dimmingView = [[UIView alloc] init];
    self.dimmingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    self.dimmingView.alpha = 0.0f;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)];
    [self.dimmingView addGestureRecognizer:tap];
}


- (void) dimmingViewTapped: (UIGestureRecognizer *) gesture
{
    if ([gesture state] == UIGestureRecognizerStateRecognized) {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void) presentationTransitionWillBegin
{
    UIView *containerView = self.containerView;
    UIViewController *presentedViewController = self.presentedViewController;
    
    [self.dimmingView setFrame:containerView.bounds];
    [self.dimmingView setAlpha:0.0f];
    
    [containerView insertSubview:self.dimmingView atIndex:0];
    
    if([presentedViewController transitionCoordinator])
    {
        [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
            // Fade the dimming view to be fully visible
            
            [[self dimmingView] setAlpha:1.0];
        } completion:nil];
        
    } else {
        
        [self.dimmingView setAlpha:1.0f];
        
    }
    
}

- (void) dismissalTransitionWillBegin
{
    if (self.presentedViewController.transitionCoordinator) {
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [self.dimmingView setAlpha:0.0f];
        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            nil;
        }];
        
    } else {
        
        [self.dimmingView setAlpha:0.0f];
        
    }
}


- (UIModalPresentationStyle)adaptivePresentationStyle
{
    return UIModalPresentationOverFullScreen;
}


- (CGSize) sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    return CGSizeMake((parentSize.width / 1.2), parentSize.height);
}


- (void) containerViewWillLayoutSubviews
{
    [self.dimmingView setFrame:self.containerView.bounds];
    [self.presentedView setFrame:self.frameOfPresentedViewInContainerView];
}

- (BOOL) shouldPresentInFullscreen
{
    return YES;
}


- (CGRect) frameOfPresentedViewInContainerView
{
    CGRect presentedViewFrame = CGRectZero;
    CGRect containerBounds = self.containerView.bounds;
    presentedViewFrame.size = [self sizeForChildContentContainer:(UIViewController <UIContentContainer> *) [self presentedViewController] withParentContainerSize:containerBounds.size];
    //presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width;
    presentedViewFrame.origin.x = 0;
    
    
    return presentedViewFrame;
    
}




@end