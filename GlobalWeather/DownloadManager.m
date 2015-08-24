//
//  DownloadManager.m
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import "DownloadManager.h"
#import "Reachability.h"
@interface DownloadManager ()
{
    NSURL *_url;
    NSString *_task;
}
@end



@implementation DownloadManager

- (instancetype) initWithURL:(NSURL *)URL AndTask:(NSString *)task
{
    self = [super init];
    if (self) {
        _url = URL;
        _task = task;
    }
    return self;
}

- (void)downloadData:(id<DownloadManagerDelegate>)delegate
{
   
    
    
    Reachability *reachabilityYandex = [Reachability reachabilityWithHostName:@"www.yandex.ru"];
    Reachability *reachabilityOpenWeather = [Reachability reachabilityWithHostName:@"www.openweathermap.org"];
    NetworkStatus currentNetworkStatusForYandex = [reachabilityYandex currentReachabilityStatus];
    NetworkStatus currentNetworkStatusForOpenWeather = [reachabilityOpenWeather currentReachabilityStatus];
    
    
    
    if (currentNetworkStatusForYandex == NotReachable || currentNetworkStatusForOpenWeather == NotReachable) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"No Internet" object:self];
        
    } else {
        
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithURL:_url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([_task isEqualToString:@"cityList"]) {
                    [delegate downloadManagerFinishedDownloadingCityListWithData:data];
                }
                
                if ([_task isEqualToString:@"dayForecast"]) {
                    [delegate downloadManagerFinishedDownloadingDayForecastWithData:data];
                }
                
                if ([_task isEqualToString:@"threeDayForecast"]) {
                    [delegate downloadManagerFinishedDownloadingThreeDayForecastWithData:data];
                }
                
                if ([_task isEqualToString:@"coordinates"]) {
                    [delegate downloadManagerFinishedDownloadingCityListViaCoordinatesWithData:data];
                }
            });
            
        }];
        
        [task resume];
    }

}
@end
