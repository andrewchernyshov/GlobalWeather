//
//  AppCore.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "AppCore.h"
#import <CoreLocation/CoreLocation.h>

@interface AppCore () <CLLocationManagerDelegate>
{
    NSMutableArray *cityListLibrary;
    Parcer *parcer;
    CityRequest *cityRequest;
    NSString *lat;
    NSString *lon;
    CLLocationManager *locationManager;
}

@end



@implementation AppCore



+ (AppCore *) sharedInstance
{
    static AppCore *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
    
        _sharedInstance = [[AppCore alloc] init];
    
    });
    
    return _sharedInstance;
}

- (CLLocationManager *) locationManager
{
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    return locationManager;
}

- (CityRequest *)cityRequest
{
    if (!cityRequest) {
        cityRequest = [[CityRequest alloc] init];
    }
    return cityRequest;
}

- (ForecastObject *)dayForecast
{
    if (!_dayForecast) {
        _dayForecast = [[ForecastObject alloc] init];
    }
    return _dayForecast;
}

- (Parcer *) parcer
{
    if (!parcer) {
        parcer = [[Parcer alloc] init];
    }
    
    return parcer;
}

- (NSMutableArray *)cityListLibrary
{
    if (!cityListLibrary) {
        cityListLibrary = [[NSMutableArray alloc] init];
    }
    return cityListLibrary;
}

- (NSMutableArray *) fetchCityList
{
    
    return [self cityListLibrary];
}


- (void) getForecastForCurrentLocation
{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
}


- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager has encountered error: %@", error);
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    lat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    lon = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://geocode-maps.yandex.ru/1.x/?format=json&geocode=%@,%@", lon, lat]];
    DownloadManager *downloadManager = [[DownloadManager alloc] initWithURL:url AndTask:@"coordinates"];
    [downloadManager downloadData:self];
    
}

- (void) downloadManagerFinishedDownloadingCityListViaCoordinatesWithData:(NSData *)data
{
    [[self parcer] setData:data];
    cityListLibrary = [[self parcer] parceCityList];
    CityRequest *request = [cityListLibrary objectAtIndex:0];
    [self getForecastWithRequest:request];
}


- (void) getNewCityListWithRequest:(NSString *)request
{
    NSString *codedRequest = [request stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://geocode-maps.yandex.ru/1.x/?format=json&geocode=%@", codedRequest]];
    DownloadManager *downloadManager = [[DownloadManager alloc] initWithURL:url AndTask:@"cityList"];
    [downloadManager downloadData:self];

}

- (void) downloadManagerFinishedDownloadingCityListWithData:(NSData *)data
{
        [[self parcer] setData:data];
        cityListLibrary = [[self parcer] parceCityList];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cityList" object:self];
   
}



- (void) getForecastWithRequest:(CityRequest *)request
{
    cityRequest = request;
    NSArray *devidedCoordinates = [request.coordinates componentsSeparatedByString:@" "];
    lat = [devidedCoordinates objectAtIndex:1];
    lon = [devidedCoordinates objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&cnt=4&mode=json&APPID=7099e347b14e30461a20a65f60e11a89", lat, lon]];
    DownloadManager *downloadManager = [[DownloadManager alloc] initWithURL:url AndTask:@"dayForecast"];
    [downloadManager downloadData:self];
    
}


- (void) downloadManagerFinishedDownloadingDayForecastWithData:(NSData *)data
{
    [[self parcer] setData:data];
    _dayForecast = [[self parcer] parceDayForecast];
    [[self dayForecast] setCityName:[[self cityRequest] cityName]];
    [[self dayForecast] setRegion:[[self cityRequest] region]];
    [[self dayForecast] setCoordinates:[[self cityRequest] coordinates]];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=4&mode=json&APPID=7099e347b14e30461a20a65f60e11a89", lat, lon]];
    DownloadManager *downloadManager = [[DownloadManager alloc] initWithURL:url AndTask:@"threeDayForecast"];
    [downloadManager downloadData:self];
}


- (void) downloadManagerFinishedDownloadingThreeDayForecastWithData:(NSData *)data
{
    [[self parcer] setData:data];
    _threeDaysForecast = [[self parcer] parceThreeDaysForecast];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"forecast" object:self];
    
}


- (void) updateCurrentForecast
{
    [self getForecastWithRequest:cityRequest];
}


   
   
    




@end




























