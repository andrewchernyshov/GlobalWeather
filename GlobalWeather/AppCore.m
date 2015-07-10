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
    NSMutableArray *library;
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

- (NSMutableArray *) fetchCityList
{
    if (!library) {
        library = [[NSMutableArray alloc] init];
    }
    return library;
}

@end
