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


- (NSMutableArray *)parceThreeDaysForecast
{
    
    int curDay;
    int curDay1;
    int curDay2;
    
    
    
    NSMutableArray *weekdayArray = [[NSMutableArray alloc] init];
    NSMutableArray *windSpeedArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempData = [[NSMutableArray alloc] init];
    NSMutableArray *discriptionArray = [[NSMutableArray alloc] init];
    NSDictionary *allDataDictionary1 = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    
    
    
    NSArray *arrayOfList = [allDataDictionary1 objectForKey:@"list"];
    for (NSDictionary *diction in arrayOfList) {
        NSString *dayTime = [diction objectForKey:@"dt"];
        NSNumber *windSpeed = [diction objectForKey:@"speed"];
        
        [weekdayArray addObject:dayTime];
        [windSpeedArray addObject: windSpeed];
        
        
        
        NSDictionary *temp = [diction objectForKey:@"temp"];
        NSString *currentTemp = [temp objectForKey:@"day"];
        [tempData addObject:currentTemp];
        
        NSArray *arrayOfWeather = [diction objectForKey:@"weather"];
        for (NSDictionary *diction2 in arrayOfWeather) {
            NSString *weatherDiscr = [diction2 objectForKey:@"description"];
            
            [discriptionArray addObject:weatherDiscr];
        }
        
    }
    
    
    
    
    NSString *temp1 = [tempData objectAtIndex:1];
    NSString *temp2 = [tempData objectAtIndex:2];
    NSString *temp3 = [tempData objectAtIndex:3];
    NSNumber *temp1Num = [NSNumber numberWithFloat:[temp1 floatValue]- 273];
    NSNumber *temp2Num = [NSNumber numberWithFloat:[temp2 floatValue]- 273];
    NSNumber *temp3Num = [NSNumber numberWithFloat:[temp3 floatValue]- 273];
    
    
    
    
    [[self numberFormatter] setRoundingMode:NSNumberFormatterRoundHalfUp];
    [[self numberFormatter] setNumberStyle:NSNumberFormatterDecimalStyle];
    [[self numberFormatter] setMaximumFractionDigits:0];
    
    
    NSString *temp1Final = [[self numberFormatter] stringFromNumber:temp1Num];
    
    NSString *temp2Final = [[self numberFormatter] stringFromNumber:temp2Num];
    NSString *temp3Final = [[self numberFormatter] stringFromNumber:temp3Num];
    
    
    
    
    NSString *day1WindSpeed = [[self numberFormatter] stringFromNumber:[windSpeedArray objectAtIndex:1]];
    NSString *day2WindSpeed = [[self numberFormatter] stringFromNumber:[windSpeedArray objectAtIndex:2]];
    NSString *day3WindSpeed = [[self numberFormatter] stringFromNumber:[windSpeedArray objectAtIndex:3]];
    
    NSString *day1 = [weekdayArray objectAtIndex:1];
    curDay = [day1 intValue];
    NSString *day2 = [weekdayArray objectAtIndex:2];
    curDay1 = [day2 intValue];
    NSString *day3 = [weekdayArray objectAtIndex:3];
    curDay2 = [day3 intValue];
    
    
    
    NSString *weatherDiscrFinal = [discriptionArray objectAtIndex:1];
    NSString *weatherDiscrFinal1 = [discriptionArray objectAtIndex:2];
    NSString *weatherDiscrFinal2 = [discriptionArray objectAtIndex:3];
    
    [[self dateFormatter] setDateFormat:@"EEE"];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:curDay];
    NSDate *currentDate1 = [NSDate dateWithTimeIntervalSince1970:curDay1];
    NSDate *currentDate2 = [NSDate dateWithTimeIntervalSince1970:curDay2];
    
    NSString *weekdayFinal = [[self dateFormatter] stringFromDate:currentDate];
    NSString *weekdayFinal1 = [[self dateFormatter] stringFromDate:currentDate1];
    NSString *weekdayFinal2 = [[self dateFormatter] stringFromDate:currentDate2];
    
    
    
    NSArray *temperatureFinal = [[NSArray alloc] initWithObjects:temp1Final, temp2Final, temp3Final, nil];
    NSArray *weekDayFinal = [[NSArray alloc] initWithObjects:weekdayFinal, weekdayFinal1, weekdayFinal2, nil];
    NSArray *windSpeedFinal = [[NSArray alloc] initWithObjects:day1WindSpeed,day2WindSpeed, day3WindSpeed, nil];
    NSArray *weatherDiscriptionFinal = [[NSArray alloc] initWithObjects:weatherDiscrFinal, weatherDiscrFinal1, weatherDiscrFinal2, nil];
    
        NSMutableArray *threeDaysForecastArray = [[NSMutableArray alloc] init];
    
    int i;
    
    for (i = 0; i<=2; i++) {
        
        ForecastObject *forecastObject = [[ForecastObject alloc] init];
        [forecastObject setCurrentTemperature:[temperatureFinal objectAtIndex:i]];
        [forecastObject setWeekDay:[weekDayFinal objectAtIndex:i]];
        [forecastObject setWindSpeed:[windSpeedFinal objectAtIndex:i]];
        [forecastObject setWeatherDiscription:[weatherDiscriptionFinal objectAtIndex:i]];
        
        [threeDaysForecastArray addObject:forecastObject];
        
    }
    
    
    return threeDaysForecastArray;
   
}


@end











