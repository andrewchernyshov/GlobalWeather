//
//  SBViewController.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCore.h"
#import "CityRequest.h"

@protocol SBViewControllerDelegate <NSObject>

- (void) dismissSBViewController;

@end




@interface SBViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UISearchBar *mySearchBar;
    IBOutlet UITableView *myTableView;
    IBOutlet UIActivityIndicatorView *sbvcActivityIndicator;
}

@property (nonatomic, weak) id <SBViewControllerDelegate> delegate;

@end
