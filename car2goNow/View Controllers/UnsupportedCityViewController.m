//
//  UnsupportedCityViewController.m
//  RideScout
//
//  Created by Brady Miller on 8/11/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "UnsupportedCityViewController.h"
#import "constantsAndMacros.h"

@interface UnsupportedCityViewController ()

@property (nonatomic, strong) IBOutlet UIView *nonEmailView;
@property (nonatomic, strong) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) IBOutlet UILabel *weWillEmailLabel;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *keyboardHeight;

@end

@implementation UnsupportedCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"tap to enter your email" attributes:@{NSForegroundColorAttributeName:BCYCLE_LIGHT_PURPLE}];
    
    self.cityLabel.text = self.cityName;
    self.weWillEmailLabel.text = [NSString stringWithFormat:@"%@%@.", self.weWillEmailLabel.text, self.cityName];
    self.emailTextField.tintColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {

}

#pragma mark - IBActions

- (IBAction)submitButtonPressed:(id)sender {
    // Make the api call for unsupported city email list.
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.emailTextField setFont:[UIFont fontWithName:@"OpenSans-Light" size:28]];
    self.submitButton.hidden = NO;
    
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    self.keyboardHeight.constant = height + 200;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [UIView animateWithDuration:animationDuration / 2 animations:^{
        self.nonEmailView.alpha = 0.0;
    }];
}

@end
