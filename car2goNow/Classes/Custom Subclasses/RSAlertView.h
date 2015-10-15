//
//  RSAlertView.h
//  RideScout
//
//  Created by Jose Bigio on 2/5/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "constantsAndMacros.h"

@protocol RSAlertViewDelegate

@optional
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface RSAlertView : UIView<RSAlertViewDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)

@property (nonatomic, weak) id<RSAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;

@property (copy) void (^onButtonTouchUpInside)(RSAlertView *alertView, int buttonIndex) ;

- (instancetype)init;
- (void)show;
- (void)close;

- (void)customIOS7dialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(RSAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;
- (NSString*)getText;

- (void)createContentWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle andPlaceHolder:(NSString *)placeHolder;
-(void)shakeFor: (CGFloat)seconds andChangeTitleTo:(NSString*)title andSubtitleTo: (NSString*)subTitle andPlaceHolder:(NSString *)placeHolder andButtonTitles:(NSArray*)buttonTitlesx;
- (void)shakeViewFor:(CGFloat)seconds;
- (instancetype)initWithTitle:(NSString*)title message:(NSString *)message placeHolder:(NSString*)placeHolder delegate:(id)_delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
