//
//  ConfigManager.h
//  RideScout
//
//  Created by Brady Miller on 2/25/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Configuration.h"

@interface ConfigManager : NSObject

@property (nonatomic, strong) Configuration *configuration;
@property (nonatomic, assign) BOOL updating;

+ (ConfigManager *)sharedConfiguration;

- (void)getConfig;

@end
