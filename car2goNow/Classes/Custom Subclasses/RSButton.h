//
//  RSButton.h
//  RideScout
//
//  Created by Brady Miller on 3/2/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Provider.h"
#import "Feature.h"

IB_DESIGNABLE
@interface RSButton : UIButton

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) Feature *feature;
@property (nonatomic, strong) Provider *provider;

@end
