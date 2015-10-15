//
//  MessagePopup.h
//  RideScout
//
//  Created by Jason Dimitriou on 7/27/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <RideKit/RKPinPopup.h>
#import "RSLabel.h"

@interface MessagePopup : RKPopup

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subtitle;

@end
