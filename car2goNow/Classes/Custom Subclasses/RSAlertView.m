//
//  RSAlertView.m
//  RideScout
//
//  Created by Jose Bigio on 2/5/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "RSAlertView.h"
#import <QuartzCore/QuartzCore.h>

const static CGFloat kCustomIOS7AlertViewDefaultButtonHeight       = 50;
const static CGFloat kCustomIOS7AlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kCustomIOS7AlertViewCornerRadius              = 7;
const static CGFloat kCustomIOS7MotionEffectExtent                 = 10.0;


@interface RSAlertView()

@property (nonatomic,strong) UITextField* textField;
@property (nonatomic,strong) NSMutableArray *divisorLines;
@property (nonatomic,strong) NSMutableArray *buttonsArray;
@property (nonatomic,strong) UIView *divisorLine;

@end

#define SUBTITLE_OFFSET 10
#define TEXTFIELD_OFFSET 10
#define TITLE_OFFSET 10
#define BOTTOM_OFFSET 10

#define BIG_WIDTH 240
#define SMALL_WIDTH 200
#define CONTAINER_WIDTH 290


@implementation RSAlertView

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

@synthesize parentView, onButtonTouchUpInside;
@synthesize delegate;
@synthesize buttonTitles;
@synthesize useMotionEffects;

- (id)initWithParentView: (UIView *)_parentView {
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}

- (instancetype)init {
    return [self initWithTitle:@"" message:@"" placeHolder:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
}

- (instancetype)initWithTitle:(NSString*)title message:(NSString *)message placeHolder:(NSString*)placeHolder delegate:(id)_delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        self.delegate = _delegate;
        useMotionEffects = false;
        buttonTitles = @[cancelButtonTitle];
        self.divisorLines = [[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [self createContentWithTitle:title andSubTitle:message andPlaceHolder:placeHolder];
        
        NSMutableArray* buttonTitlesArray = [[NSMutableArray alloc]init];
        [buttonTitlesArray addObject:cancelButtonTitle];
        if (otherButtonTitles) {
            va_list args;
            va_start(args, otherButtonTitles);
            for (NSString *title = otherButtonTitles; title!=nil; title = va_arg(args, NSString*)) {
                [buttonTitlesArray addObject:title];
            }
        }
        
        self.buttonTitles = buttonTitlesArray;
    }
    
    return self;
}

// Create the dialog view, and animate opening the dialog
- (void)show {
    self.dialogView = [self createContainerView];
    
    self.dialogView.layer.shouldRasterize = YES;
    self.dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
#if (defined(__IPHONE_7_0))
    if (useMotionEffects) {
        [self applyMotionEffects];
    }
#endif
    
    self.dialogView.layer.opacity = 0.5f;
    self.dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.dialogView];
    
    // Can be attached to a view or to the top most window
    // Attached to a view:
    if (parentView != NULL) {
        [parentView addSubview:self];
        
        // Attached to the top most window (make sure we are using the right orientation):
    } else {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.dialogView.layer.opacity = 1.0f;
                         self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
    
    [self.textField becomeFirstResponder];
}

// Button has been touched
- (void)customIOS7dialogButtonTouchUpInside:(id)sender {
    [self close];
    
    if (onButtonTouchUpInside != NULL) {
        onButtonTouchUpInside(self, (int)[sender tag]);
    }
    else if (delegate != NULL) {
        [delegate customIOS7dialogButtonTouchUpInside:self clickedButtonAtIndex:[sender tag]];
    }
//    else if (self.buttonsArray.count == 1) {
//        [self close];
//    }
}

// Default button behaviour
- (void)customIOS7dialogButtonTouchUpInside: (RSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self close];
}

- (NSString *) getText{
    return self.textField.text;
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close {
    CATransform3D currentTransform = self.dialogView.layer.transform;
    
    CGFloat startRotation = [[self.dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
    
    self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    self.dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}



- (void)setSubView: (UIView *)subView {
    self.containerView = subView;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView {
    if (self.containerView == NULL) {
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }
    
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
    
    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    CGFloat cornerRadius = kCustomIOS7AlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor lightGrayColor],
                       nil];
    [dialogContainer.layer insertSublayer:gradient atIndex:0];
    
    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.borderColor = [COOPER_GRAY CGColor];
    dialogContainer.layer.borderWidth = 1;
 
    // There is a line above the button
    self.divisorLine = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, buttonSpacerHeight)];
    self.divisorLine.backgroundColor = COOPER_GRAY;
    [dialogContainer addSubview:self.divisorLine];
   
    // Add the custom container if there is any
    [dialogContainer addSubview:self.containerView];
    
    // Add the buttons too
    [self addButtonsToView:dialogContainer];
    dialogContainer.backgroundColor = RIDESCOUT_WHITE;

    return dialogContainer;
}

// Helper function: add buttons to container
- (void)addButtonsToView:(UIView *)container {
    if (buttonTitles == NULL) {
        return;
    }
    
    CGFloat buttonWidth = container.bounds.size.width / [buttonTitles count];
    self.buttonsArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[buttonTitles count]; i++) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [closeButton setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
        [closeButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        
        [closeButton setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton setTitleColor:BCYCLE_LIGHT_PURPLE forState:UIControlStateNormal];
        closeButton.backgroundColor = [UIColor clearColor];
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:14]];
        [closeButton.layer setCornerRadius:kCustomIOS7AlertViewCornerRadius];
        [container addSubview:closeButton];
        [container sendSubviewToBack:closeButton];
        [self.buttonsArray addObject:closeButton];
        
        if ( i < [buttonTitles count] - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * buttonWidth+buttonWidth,container.bounds.size.height - buttonHeight , 1, buttonHeight)];
            lineView.backgroundColor = COOPER_GRAY;
            [container addSubview:lineView];
            [self.divisorLines addObject:lineView];
        }
        
        if (i == 0 && buttonTitles.count > 1) {
            [closeButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:14]];
        }
        
    }
}

// Helper function: count and return the dialog's size
- (CGSize)countDialogSize {
    CGFloat dialogWidth = self.containerView.frame.size.width;
    CGFloat dialogHeight = self.containerView.frame.size.height + buttonHeight + buttonSpacerHeight;
    
    return CGSizeMake(dialogWidth, dialogHeight);
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize {
    if (buttonTitles!=NULL && [buttonTitles count] > 0) {
        buttonHeight       = kCustomIOS7AlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomIOS7AlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = screenWidth;
        screenWidth = screenHeight;
        screenHeight = tmp;
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [self.dialogView addMotionEffect:motionEffectGroup];
}
#endif

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification {
    // If dialog is attached to the parent view, it probably wants to handle the orientation change itself
    if (parentView != NULL) {
        return;
    }
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogView.transform = rotation;
                     }
                     completion:^(BOOL finished){
                         // fix errors caused by being rotated one too many times
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             UIInterfaceOrientation endInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                             if (interfaceOrientation != endInterfaceOrientation) {
                                 // TODO user moved phone again before than animation ended: rotation animation can introduce errors here
                             }
                         });
                     }
     ];
}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification {
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification {
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

- (void)createContentWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle andPlaceHolder:(NSString *)placeHolder {
//    CGFloat subTitleOffset = 10;
//    CGFloat textFieldOffset = 10;
//    CGFloat titleOffset = 10;
//    CGFloat bottomOffset = 10;
//    
//    CGFloat bigWidth = 240;
//    CGFloat smallWidth = 200;
//    CGFloat containerWidth = 290;
    
    UIFont *titleFont = [UIFont fontWithName:@"Gotham-Book" size:16];
    UIFont *subTitleFont = [UIFont fontWithName:@"OpenSans" size:12];
    
    CGFloat xOffset = CONTAINER_WIDTH/2-SMALL_WIDTH/2;
    
    CGSize constraintSize = CGSizeMake(SMALL_WIDTH,MAXFLOAT);
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:titleFont}];
    CGFloat labelHeight = [attributedText boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, TITLE_OFFSET, SMALL_WIDTH, labelHeight)];
    self.titleLabel.font = titleFont;
    self.titleLabel.textColor = BCYCLE_DARK_GREY;
    self.titleLabel.numberOfLines = 1.0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.5;
    self.titleLabel.text = title;
    
    
    constraintSize = CGSizeMake(BIG_WIDTH,MAXFLOAT);
    attributedText = [[NSAttributedString alloc] initWithString:subTitle attributes:@{NSFontAttributeName:subTitleFont}];
    labelHeight = [attributedText boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    xOffset = CONTAINER_WIDTH/2-BIG_WIDTH/2;
    
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height + SUBTITLE_OFFSET, BIG_WIDTH, labelHeight)];
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.text = subTitle;
    self.subTitleLabel.font = subTitleFont;
    self.subTitleLabel.textColor = BCYCLE_DARK_GREY;
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *containerViewx;
    if (placeHolder) {
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(xOffset,  self.subTitleLabel.frame.origin.y+ self.subTitleLabel.frame.size.height+TEXTFIELD_OFFSET, BIG_WIDTH, 25)];
        self.textField .layer.borderColor = [UIColor grayColor].CGColor;
        self.textField .layer.borderWidth = 1.0;
        self.textField .placeholder = placeHolder;
        self.textField .contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField .backgroundColor = [UIColor whiteColor];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.textField  setLeftViewMode:UITextFieldViewModeAlways];
        [self.textField  setLeftView:spacerView];
        
       containerViewx = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONTAINER_WIDTH, SUBTITLE_OFFSET + TITLE_OFFSET + TEXTFIELD_OFFSET + self.textField .frame.size.height +  self.subTitleLabel.frame.size.height + self.titleLabel.frame.size.height + BOTTOM_OFFSET)];
        [containerViewx addSubview:self.textField ];
    }
    else {
        containerViewx = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CONTAINER_WIDTH, SUBTITLE_OFFSET + TITLE_OFFSET +  self.subTitleLabel.frame.size.height + self.titleLabel.frame.size.height + BOTTOM_OFFSET)];
    }
    
    
    [containerViewx addSubview:self.titleLabel];
    [containerViewx addSubview:self.subTitleLabel];
    
    
    self.containerView = containerViewx;
}

#pragma mark - shakyness

-(void)shakeFor: (CGFloat)seconds andChangeTitleTo:(NSString*)title andSubtitleTo: (NSString*)subTitle andPlaceHolder:(NSString *)placeHolder andButtonTitles:(NSArray*)buttonTitlesx {
//    containerView.backgroundColor = [UIColor blueColor];
//    self.dialogView.backgroundColor = [UIColor redColor];
    //[self createContentWithTitle:title andSubTitle:subTitle andPlaceHolder:placeHolder];
    [self shakeViewFor:seconds];
    __weak __typeof__(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds *0.95* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        //figure out if the subtitle will fit inside the container
        CGSize constraintSize = CGSizeMake(BIG_WIDTH,MAXFLOAT);
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:subTitle attributes:@{NSFontAttributeName:weakSelf.textField.font}];
        CGFloat labelHeight = [attributedText boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        CGRect frame = weakSelf.subTitleLabel.frame;
        frame.size.height = labelHeight;
        weakSelf.subTitleLabel.frame = frame;
        
        CGFloat oldSize = weakSelf.containerView.frame.size.height;
        CGFloat newSize;
        
        
        if (placeHolder) {
            weakSelf.textField.placeholder = placeHolder;
            newSize = SUBTITLE_OFFSET + TITLE_OFFSET + TEXTFIELD_OFFSET + weakSelf.textField.frame.size.height +  weakSelf.subTitleLabel.frame.size.height + weakSelf.titleLabel.frame.size.height + BOTTOM_OFFSET;
        } else{
            [weakSelf.textField removeFromSuperview];
            newSize = SUBTITLE_OFFSET + TITLE_OFFSET +  weakSelf.subTitleLabel.frame.size.height + weakSelf.titleLabel.frame.size.height + BOTTOM_OFFSET;
        }
        
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakSelf.titleLabel.text = title;
                             weakSelf.subTitleLabel.text = subTitle;
                             CGFloat offset = newSize-oldSize;
                             CGRect frame = weakSelf.dialogView.frame;
                             frame.size.height+=offset;
                             weakSelf.dialogView.frame = frame;
                             frame = weakSelf.containerView.frame;
                             frame.size.height+=offset;
                             weakSelf.containerView.frame = frame;
                             frame = weakSelf.divisorLine.frame;
                             frame.origin.y+=offset;
                             weakSelf.divisorLine.frame = frame;
                             for(UIView *view in weakSelf.divisorLines) {
                                 [view removeFromSuperview];
                             }
                             for(UIView *view in weakSelf.buttonsArray) {
                                 [view removeFromSuperview];
                             }
                        }
                         completion:^(BOOL finished){
                             if(buttonTitlesx) {
                                 weakSelf.buttonTitles = buttonTitlesx;
                             }
                             else {
                                 weakSelf.buttonTitles = @[@"Cancel"];
                             }
                             [weakSelf addButtonsToView:weakSelf.dialogView];
                         }
         ];
    });
}

- (void)shakeViewFor:(CGFloat)seconds
{
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 0.2;
    animation.cumulative = NO;
    animation.repeatCount = MAXFLOAT;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat: 0.0],
                        [NSNumber numberWithFloat: DEGREES_TO_RADIANS(-4.0)],
                        [NSNumber numberWithFloat: 0.0],
                        [NSNumber numberWithFloat: DEGREES_TO_RADIANS(4.0)],
                        [NSNumber numberWithFloat: 0.0], nil];
    animation.fillMode = kCAFillModeBoth;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    [[self.dialogView layer] addAnimation:animation forKey:@"effect"];
    
    __weak __typeof__(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[weakSelf.dialogView layer]removeAnimationForKey:@"effect"];
    });
}

@end
