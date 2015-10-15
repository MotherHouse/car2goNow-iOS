//
//  ProfileViewController.h
//  RideScout
//
//  Created by Charlie Cliff on 6/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSLabel;

@interface RSGradientView :UIView

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *mainView;

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, strong) UIButton *profileButton;

- (void)viewWillTransitionOntoScreen;

@end
