//
//  AppCore.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityRequest.h"

@interface AppCore : NSObject 

+ (AppCore *) sharedInstance;

- (NSMutableArray *) fetchCityList;

@end
