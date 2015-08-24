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

@property (nonatomic, strong) NSMutableArray *cityListLibrary;
@property (nonatomic, strong) Parcer *parcer;
@property (nonatomic, strong) CityRequest *cityRequest;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) CLLocationManager *locationManager;


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
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return _locationManager;
}

- (CityRequest *)cityRequest
{
    if (!_cityRequest) {
        _cityRequest = [[CityRequest alloc] init];
    }
    return _cityRequest;
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
    if (!_parcer) {
        _parcer = [[Parcer alloc] init];
    }
    
    return _parcer;
}

- (NSMutableArray *)cityListLibrary
{
    if (!_cityListLibrary) {
        _cityListLibrary = [[NSMutableArray alloc] init];
    }
    return _cityListLibrary;
}

- (NSMutableArray *) fetchCityList
{
    NSLog(@"City List Count = %lu", (unsigned long)[self.cityListLibrary count]);
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
    self.lat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    self.lon = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://geocode-maps.yandex.ru/1.x/?format=json&geocode=%@,%@", self.lon, self.lat]];
    DownloadManager *downloadManager = [[DownloadManager alloc] initWithURL:url AndTask:@"coordinates"];
    [downloadManager downloadData:self];
    
}

- (void) downloadManagerFinishedDownloadingCityListViaCoordinatesWithData:(NSData *)data
{
    [[self parcer] setData:data];
    self.cityListLibrary = [[self parcer] parceCityList];
    CityRequest *request = [self.cityListLibrary objectAtIndex:0];
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
        self.cityListLibrary = [[self parcer] parceCityList];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cityList" object:self];
   
}



- (void) getForecastWithRequest:(CityRequest *)request
{
    self.cityRequest = request;
    NSArray *devidedCoordinates = [request.coordinates componentsSeparatedByString:@" "];
    self.lat = [devidedCoordinates objectAtIndex:1];
    self.lon = [devidedCoordinates objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&cnt=4&mode=json&APPID=7099e347b14e30461a20a65f60e11a89", self.lat, self.lon]];
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
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=4&mode=json&APPID=7099e347b14e30461a20a65f60e11a89", self.lat, self.lon]];
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
    [self getForecastWithRequest:self.cityRequest];
}


   
   
    




@end




























