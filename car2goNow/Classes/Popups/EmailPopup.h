//
//  EmailPopup.h
//  Bcycle
//
//  Created by Charlie Cliff on 9/30/15.
//  Copyright © 2015 ridescout. All rights reserved.
//

#import <RideKit/RideKit.h>

@class RSLabel;

@interface EmailPopup : RKPopup

@property (nonatomic, strong) RSLabel *cancelLabel;
@property (nonatomic, strong) RSLabel *acceptLabel;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UIImageView *buttonSeparatorImageView;

@end
