//
//  CityRequest.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityRequest : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *coordinates;

@end

