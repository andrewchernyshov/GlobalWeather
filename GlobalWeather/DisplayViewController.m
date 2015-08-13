//
//  DisplayViewController.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "DisplayViewController.h"

@interface DisplayViewController () <AppCoreDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favouritesHeightConstaint;

@end

@implementation DisplayViewController

- (void) internetConnectionIsUnAvailable
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Inernet access problem" message:@"Internet connection is unavailable right now." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void) swipeAction: (UISwipeGestureRecognizer *) sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        [self addCity:nil];

    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        [[AppCore sharedInstance] updateCurrentForecast];
        [dvcActivityIndicator startAnimating];
    
    }
}


- (void) cityChoiseCanceled: (NSNotification *) notification
{
    [dvcActivityIndicator stopAnimating];
}

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
    
    
    [day1WeekDayLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:0] weekDay]];
    [day1WeekDayLabel setEnabled:YES];
    [day1TemperatureLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:0] currentTemperature]];
    [day1TemperatureLabel setEnabled:YES];
    [day1WindSpeedLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:0] windSpeed]];
    [day1WindSpeedLabel setEnabled:YES];
    [day1WeatherDiscriptionLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:0] weatherDiscription]];
    [day1WeatherDiscriptionLabel setEnabled:YES];
    
    [day2WeekDayLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:1] weekDay]];
    [day2WeekDayLabel setEnabled:YES];
    [day2TemperatureLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:1] currentTemperature]];
    [day2TemperatureLabel setEnabled:YES];
    [day2WindSpeedLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:1] windSpeed]];
    [day2WindSpeedLabel setEnabled:YES];
    [day2WeatherDiscriptionLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:1] weatherDiscription]];
    [day2WeatherDiscriptionLabel setEnabled:YES];
    
    [day3WeekDayLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:2] weekDay]];
    [day3WeekDayLabel setEnabled:YES];
    [day3TemperatureLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:2] currentTemperature]];
    [day3TemperatureLabel setEnabled:YES];
    [day3WindSpeedLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:2] windSpeed]];
    [day3WindSpeedLabel setEnabled:YES];
    [day3WeatherDiscriptionLabel setText:[[[[AppCore sharedInstance] threeDaysForecast] objectAtIndex:2] weatherDiscription]];
    [day3WeatherDiscriptionLabel setEnabled:YES];

    
    
    [dvcActivityIndicator stopAnimating];
}


- (IBAction)addCity:(id)sender
{
    [[AppCore sharedInstance] checkConnection:self];
    SBViewController *sbvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SBViewController"];
    [self presentViewController:sbvc animated:YES completion:nil];
    [dvcActivityIndicator startAnimating];
    
}


- (IBAction)getForecastForCurrentLocation:(id)sender
{
    [[AppCore sharedInstance] getForecastForCurrentLocation];
    [dvcActivityIndicator startAnimating];
}

- (IBAction)showFavourites:(id)sender {
    
    [self.favouritesTableView reloadData];
    [self.favouritesView canBecomeFirstResponder];
    
    
    if (self.favouritesView.alpha == 0) {
        //self.favouritesViewHight.constant = 200;
        self.favouritesTableView.center = CGPointMake(CGRectGetWidth(self.favouritesView.frame)/2, 80);
        self.favouritesView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, 130);

        
        [UIView animateWithDuration:0.5f animations:^{
            [self.favouritesView setAlpha:1.0f];
            
            self.favouritesTableView.center = CGPointMake(CGRectGetWidth(self.favouritesView.frame)/2, 100);
             self.favouritesView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, 172);

            
        }];

    } else {
        
        
        [self.view canBecomeFirstResponder];
        [UIView animateWithDuration:0.5f animations:^{
            [self.favouritesView setAlpha:0.0f];
            
            self.favouritesTableView.center = CGPointMake(CGRectGetWidth(self.favouritesView.frame)/2, 80);
             self.favouritesView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, 130);
            //self.favouritesViewHight.constant = 5;

        }];
        
    }
    
    
    
    NSLog(@"Favourite");
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[AppCore sharedInstance] checkConnection:self];
    
    UISwipeGestureRecognizer *swipeUP = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [swipeUP setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUP];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeDown];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChoiseCanceled:) name:@"cityChoiseCanceled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forecastReceived:) name:@"forecast" object:nil];
    [self getForecastForCurrentLocation:nil];
    self.favouritesView.alpha = 0.0f;
    self.favouritesViewHight.constant = 210;
   
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return @"List of favourite locations";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[[AppCore sharedInstance] fetchFavouriteCityList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FavouritesCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FavouritesCell"];
    }
    
        CityRequest *currentCityRequest = [[[AppCore sharedInstance] fetchFavouriteCityList] objectAtIndex:indexPath.row];
        cell.textLabel.text = currentCityRequest.cityName;
        cell.detailTextLabel.text = currentCityRequest.region;
        

    
    
    return cell;
}


@end
