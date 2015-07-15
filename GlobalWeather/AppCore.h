//
//  AppCore.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityRequest.h"
#import "DownloadManager.h"
#import "Parcer.h"
#import <CoreLocation/CoreLocation.h>


@interface AppCore : NSObject <DownloadManagerDelegate>

@property (nonatomic, strong) ForecastObject *dayForecast;
@property (nonatomic, strong) NSMutableArray *threeDaysForecast;

+ (AppCore *) sharedInstance;

- (NSMutableArray *) fetchCityList;

- (void) getNewCityListWithRequest: (NSString *)request;

- (void) getForecastWithRequest: (CityRequest *) request;

- (void) updateCurrentForecast;

- (void) getForecastForCurrentLocation;
@end
