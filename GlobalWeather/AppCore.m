//
//  AppCore.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "AppCore.h"
@interface AppCore ()
{
    NSMutableArray *cityListLibrary;
    Parcer *parcer;
    CityRequest *cityRequest;
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
    NSString *lat = [devidedCoordinates objectAtIndex:1];
    NSString *lon = [devidedCoordinates objectAtIndex:0];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"forecast" object:self];
}



@end




























