//
//  DisplayViewController.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "DisplayViewController.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController


- (void) forecastReceived: (NSNotification *) notification
{
    [cityNameLabel setText:[[[AppCore sharedInstance] dayForecast] cityName]];
    [cityNameLabel setEnabled:YES];
    [regionLabel setText:[[[AppCore sharedInstance] dayForecast] region]];
    [regionLabel setEnabled:YES];
    [weekDayLabel setText:[[[AppCore sharedInstance] dayForecast] weekDay]];
    [weekDayLabel setEnabled:YES];
    [weatherDiscriptionLabel setText:[[[AppCore sharedInstance] dayForecast] weatherDiscription]];
    [weatherDiscriptionLabel setEnabled:YES];
    [temperatureLabel setText:[[[AppCore sharedInstance] dayForecast] currentTemperature]];
    [temperatureLabel setEnabled:YES];
    [humidityRateLabel setText:[[[AppCore sharedInstance] dayForecast] humidityRate]];
    [humidityRateLabel setEnabled:YES];
    [sunriseTimeLabel setText:[[[AppCore sharedInstance] dayForecast] sunriseTime]];
    [sunriseTimeLabel setEnabled:YES];
    [sunsetTimeLabel setText:[[[AppCore sharedInstance] dayForecast] sunsetTime]];
    [sunsetTimeLabel setEnabled:YES];
    [windSpeedLabe setText:[[[AppCore sharedInstance] dayForecast] windSpeed]];
    [windSpeedLabe setEnabled:YES];
    [dvcActivityIndicator stopAnimating];
}


- (IBAction)addCity:(id)sender
{
    SBViewController *sbvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SBViewController"];
    [self presentViewController:sbvc animated:YES completion:nil];
    [dvcActivityIndicator startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forecastReceived:) name:@"forecast" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
