//
//  AnimatedTransitioning.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 24.08.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface AnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL isPresentation;
@end
