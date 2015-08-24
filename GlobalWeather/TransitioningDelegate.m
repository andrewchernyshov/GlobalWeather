//
//  TransitioningDelegate.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 24.08.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "TransitioningDelegate.h"
#import "PresentationController.h"

@implementation TransitioningDelegate


- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    Class presentationControllerClass;
    presentationControllerClass = [PresentationController class];
    
    return [[presentationControllerClass alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (AnimatedTransitioning *)animatedTransitioning
{
    AnimatedTransitioning *animatedTransitioning = [[AnimatedTransitioning alloc] init];
    return animatedTransitioning;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    AnimatedTransitioning *animatedTransitioning = [self animatedTransitioning];
    [animatedTransitioning setIsPresentation:YES];
    return animatedTransitioning;
    
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    AnimatedTransitioning *animatedTransitioning = [self animatedTransitioning];
    [animatedTransitioning setIsPresentation:NO];
    return animatedTransitioning;
}





@end
