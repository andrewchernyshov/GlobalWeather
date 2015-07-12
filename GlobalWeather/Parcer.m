//
//  Parcer.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "Parcer.h"

@interface Parcer ()
{
    
    NSDateFormatter *dateFormatter;
    NSNumberFormatter *numberFormatter;
    
}
@end

@implementation Parcer


- (NSDateFormatter *)dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return dateFormatter;
}


- (NSNumberFormatter *)numberFormatter
{
    if (!numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
    }
    
    return numberFormatter;
}



- (NSMutableArray *) parceCityList
{
    
    NSDictionary *cityListDictionary = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    NSDictionary *responseDictionary = [cityListDictionary objectForKey:@"response"];
    NSDictionary *geoObjectCollectionDictionary = [responseDictionary objectForKey:@"GeoObjectCollection"];
    NSArray *featureMemberArray = [geoObjectCollectionDictionary objectForKey:@"featureMember"];
    NSMutableArray *cityListObjectArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in featureMemberArray) {
        NSDictionary *geoObjectDictionary = [dict objectForKey:@"GeoObject"];
        NSString *cityName = [geoObjectDictionary objectForKey:@"name"];
        
        
        NSString *cityNameDiscription = [geoObjectDictionary objectForKey:@"description"];
        
        
        NSDictionary *pointDictionary = [geoObjectDictionary objectForKey:@"Point"];
        NSString *position = [pointDictionary objectForKey:@"pos"];
        
        CityRequest *cityRequestObject = [[CityRequest alloc] init];
        [cityRequestObject setCityName:cityName];
        
        [cityRequestObject setRegion:cityNameDiscription];
        [cityRequestObject setCoordinates:position];
        
        [cityListObjectArray addObject:cityRequestObject];
        
    }
    
    
    
   
    
    return cityListObjectArray;

}

- (ForecastObject *) parceDayForecast
{
    NSDictionary *allDataDictionary1 = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    
    NSMutableArray *discriptionWeatherArray = [[NSMutableArray alloc] init];
    NSArray *weatherArray = [allDataDictionary1 objectForKey:@"weather"];
    ForecastObject *forecastObject = [[ForecastObject alloc] init];
    for (NSDictionary *dict1 in weatherArray) {
        NSString *weatherDiscription = [dict1 objectForKey:@"description"];
        [discriptionWeatherArray addObject:weatherDiscription];
    }
    
    
    NSDictionary *sysDictionary = [allDataDictionary1 objectForKey:@"sys"];
    NSString *sunrise = [sysDictionary objectForKey:@"sunrise"];
    int sunriseInt = [sunrise intValue];
    
    [[self dateFormatter] setDateFormat:@"HH:mm"];
    NSDate *sunriseDate = [NSDate dateWithTimeIntervalSince1970:sunriseInt];
    NSString *sunriseFinal = [[self dateFormatter] stringFromDate:sunriseDate];
    
    
    
    
    NSString *sunset = [sysDictionary objectForKey:@"sunset"];
    int sunsetInt = [sunset intValue];
    
    NSDate *sunsetDate = [NSDate dateWithTimeIntervalSince1970:sunsetInt];
    NSString *sunsetFinal = [[self dateFormatter] stringFromDate:sunsetDate];
    
    NSDate *CurrentDate = [NSDate date];
    
    [[self dateFormatter] setDateFormat:@"EEEE"];
    NSString *weekDay = [[self dateFormatter] stringFromDate:CurrentDate];
    
    
    NSDictionary *mainDictionary = [allDataDictionary1 objectForKey:@"main"];
    
    NSString *currentTemperature = [mainDictionary objectForKey:@"temp"];
    NSNumber *temp = [NSNumber numberWithDouble:[currentTemperature doubleValue]- 273];
    
    [[self numberFormatter] setNumberStyle:NSNumberFormatterDecimalStyle];
    [[self numberFormatter] setRoundingMode:NSNumberFormatterRoundHalfUp];
    [[self numberFormatter] setMaximumFractionDigits:0];
    NSString *tempFormated = [[self numberFormatter] stringFromNumber:temp];
    
    
    
    NSDictionary *windDictionary = [allDataDictionary1 objectForKey:@"wind"];
    NSNumber *windSpeed = [windDictionary objectForKey:@"speed"];
    NSString *windSpeedFinal = [[self numberFormatter] stringFromNumber:windSpeed];
    
    
    
    NSNumber *humidityRate = [mainDictionary objectForKey:@"humidity"];
    
    [[self numberFormatter] setMultiplier:@1];
    [[self numberFormatter] setNumberStyle:NSNumberFormatterPercentStyle];
    NSString *humidityFinal = [[self numberFormatter] stringFromNumber:humidityRate];
    
        [forecastObject setWeatherDiscription:[discriptionWeatherArray objectAtIndex:0]];
        [forecastObject setSunriseTime:sunriseFinal];
        [forecastObject setSunsetTime:sunsetFinal];
        [forecastObject setWeekDay:weekDay];
        [forecastObject setCurrentTemperature:tempFormated];
        [forecastObject setWindSpeed:windSpeedFinal];
        [forecastObject setHumidityRate:humidityFinal];
   
    



    return forecastObject;

}


@end











