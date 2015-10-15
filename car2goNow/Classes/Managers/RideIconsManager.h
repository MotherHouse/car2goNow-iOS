//
//  RideIconsManager.h
//  RideScout
//
//  Created by Brady Miller on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RideIconsManager : NSObject

+ (RideIconsManager *)sharedCache;

- (void)addImageForUrl:(NSString *)urlString withName:(NSString *)name withWidth:(int)width andHeight:(int)height;
- (UIImage *)imageIconForURL:(NSString *)urlString;
- (UIImage *)imageIconForProviderWithName:(NSString *)name;

@end
