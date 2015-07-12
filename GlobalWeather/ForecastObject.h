//
//  ForecastObject.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 12.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForecastObject : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *weekDay;
@property (nonatomic, strong) NSString *weatherDiscription;
@property (nonatomic, strong) NSString *currentTemperature;
@property (nonatomic, strong) NSString *sunriseTime;
@property (nonatomic, strong) NSString *sunsetTime;
@property (nonatomic, strong) NSString *humidityRate;
@property (nonatomic, strong) NSString *windSpeed;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, strong) NSString *coordinates;

//3DaysForecast

@property (strong, nonatomic) NSString *day1Temperature;
@property (strong, nonatomic) NSString *day1Weekday;
@property (strong, nonatomic) NSString *day1WindSpeed;
@property (strong, nonatomic) NSString *day1WeatherDiscription;

@property (strong, nonatomic) NSString *day2Temperature;
@property (strong, nonatomic) NSString *day2WeekDay;
@property (strong, nonatomic) NSString *day2WindSpeed;
@property (strong, nonatomic) NSString *day2WeatherDiscription;

@property (strong, nonatomic) NSString *day3Temperature;
@property (strong, nonatomic) NSString *day3WeekDay;
@property (strong, nonatomic) NSString *day3WindSpeed;
@property (strong, nonatomic) NSString *day3WeatherDiscription;

@end
