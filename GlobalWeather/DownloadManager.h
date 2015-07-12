//
//  DownloadManager.h
//  GlobalWeather
//
//  Created by Andrew Chernyhov on 10.07.15.
//  Copyright (c) 2015 Andrew Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DownloadManagerDelegate

@optional
- (void) downloadManagerFinishedDownloadingCityListWithData: (NSData *)data;
- (void) downloadManagerFinishedDownloadingDayForecastWithData:(NSData *)data;
- (void) downloadManagerFinishedDownloadingThreeDayForecastWithData:(NSData *)data;

@end

@interface DownloadManager : NSObject

@property (nonatomic, weak) id<DownloadManagerDelegate>delegate;

- (void)downloadData: (id<DownloadManagerDelegate>) delegate;

- (instancetype) initWithURL: (NSURL *)URL AndTask:(NSString*) task;


@end
