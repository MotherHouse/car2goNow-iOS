//
//  RSProfile.h
//  RideScout
//
//  Created by Charlie Cliff on 9/24/15.
//  Copyright © 2015 RideScout. All rights reserved.
//

#import <RideKit/RideKit.h>
#import <UIKit/UIImage.h>

@interface RSProfile : RKProfile

@property (nonatomic, strong) UIImage *image;

// BCycle
@property (nonatomic) NSInteger bCycleID; // B Cycle Account ID

@end
