//
//  DisplayViewController.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBViewController.h"

@interface DisplayViewController : UIViewController

{
    IBOutlet UILabel *cityNameLabel;
    IBOutlet UILabel *regionLabel;
}

- (IBAction)addCity:(id)sender;

@end
