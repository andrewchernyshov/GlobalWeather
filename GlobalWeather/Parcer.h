//
//  Parcer.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityRequest.h"
#import "ForecastObject.h"

@interface Parcer : NSObject

@property (nonatomic, strong) NSData *data;

- (NSMutableArray *) parceCityList;

- (ForecastObject *) parceDayForecast;

- (NSMutableArray *) parceThreeDaysForecast;

@end
