//
//  DisplayViewController.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBViewController.h"
#import "AppCore.h"

@interface DisplayViewController : UIViewController

{
    IBOutlet UIActivityIndicatorView *dvcActivityIndicator;
    
    IBOutlet UILabel *cityNameLabel;
    IBOutlet UILabel *regionLabel;
    IBOutlet UILabel *weekDayLabel;
    IBOutlet UILabel *weatherDiscriptionLabel;
    IBOutlet UILabel *temperatureLabel;
    IBOutlet UILabel *humidityRateLabel;
    IBOutlet UILabel *sunriseTimeLabel;
    IBOutlet UILabel *sunsetTimeLabel;
    IBOutlet UILabel *windSpeedLabe;
    
    IBOutlet UILabel *day1WeekDayLabel;
    IBOutlet UILabel *day1TemperatureLabel;
    IBOutlet UILabel *day1WindSpeedLabel;
    IBOutlet UILabel *day1WeatherDiscriptionLabel;
    
    IBOutlet UILabel *day2WeekDayLabel;
    IBOutlet UILabel *day2TemperatureLabel;
    IBOutlet UILabel *day2WindSpeedLabel;
    IBOutlet UILabel *day2WeatherDiscriptionLabel;
    
    IBOutlet UILabel *day3WeekDayLabel;
    IBOutlet UILabel *day3TemperatureLabel;
    IBOutlet UILabel *day3WindSpeedLabel;
    IBOutlet UILabel *day3WeatherDiscriptionLabel;
    
}

- (IBAction)addCity:(id)sender;



@end
