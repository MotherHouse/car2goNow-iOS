//
//  MintManager.h
//  RideScout
//
//  Created by Nicholas Petersen on 2/23/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MintEvents.h"

@interface MintManager : NSObject

+ (void)splunkEventWithProcess:(NSString *)process withVersion:(NSString *)version withRSFeature:(NSString *)feature withAction:(NSString *)action withMajorUIElement:(NSString *)major withMinorUIElement:(NSString *)minor withMiscellaneousMessage:(NSString *)misc;

+ (void)splunkWithString:(NSString *)splunkString event:(BOOL)event breadcrumb:(BOOL)breadcrumb;
+ (void)flush;

@end

