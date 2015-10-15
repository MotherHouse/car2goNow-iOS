//
//  MintManager.m
//  RideScout
//
//  Created by Nicholas Petersen on 2/23/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "MintManager.h"
#import <SplunkMint/SplunkMint.h>

@interface MintManager () <MintNotificationDelegate>
@end


@implementation MintManager

+ (void)splunkEventWithProcess:(NSString *)process withVersion:(NSString *)version withRSFeature:(NSString *)feature withAction:(NSString *)action withMajorUIElement:(NSString *)major withMinorUIElement:(NSString *)minor withMiscellaneousMessage:(NSString *)misc {
    NSString *eventString = @"";
    if ( process != nil ) eventString = [NSString stringWithFormat:@"%@_%@",eventString, process];
    if ( version != nil ) eventString = [NSString stringWithFormat:@"%@_%@",eventString, version];
    if ( feature != nil ) eventString = [NSString stringWithFormat:@"%@_%@",eventString, feature];
    if ( action != nil ) eventString = [NSString stringWithFormat:@"%@_%@",eventString, action];
    if ( major != nil ) {
        eventString = [NSString stringWithFormat:@"%@_%@",eventString, major];
        if ( minor != nil ) eventString = [NSString stringWithFormat:@"%@-%@",eventString, minor];

    }
    if ( misc != nil ) eventString = [NSString stringWithFormat:@"%@_%@",eventString, misc];
    
    [MintManager splunkWithString:eventString event:YES breadcrumb:YES];
}

+ (void)splunkWithString:(NSString *)splunkString event:(BOOL)event breadcrumb:(BOOL)breadcrumb {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (event) [[Mint sharedInstance] logEventAsyncWithTag:splunkString completionBlock:nil];
        if (breadcrumb) [[Mint sharedInstance] leaveBreadcrumb:splunkString];
    } );
}

+ (void)flush{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[Mint sharedInstance] flushAsyncWithBlock:nil];
    });
}

@end


