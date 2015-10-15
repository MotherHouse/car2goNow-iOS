//
//  ProfileViewController.m
//  RideScout
//
//  Created by Charlie Cliff on 6/10/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ProfileViewController.h"
#import "constantsAndMacros.h"
#import "ContactSupportWidget.h"
#import "ReceiptsWidget.h"
#import "UIImage+Circles.h"
#import "TripManager.h"
#import "RSProfileManager.h"
#import "RSLabel.h"
#import "EnterTextPopup.h"
#import "RSActionSheet.h"
#import "LaunchViewController.h"
#import "MintManager.h"
#import "AFNetworking.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "MenuPopup.h"
#import "AccountWidget.h"
#import "AppDelegate.h"
#import "RSAlertView.h"
#import "RiderInfoWidget.h"

#import <RideKit/RideKit.h>

#define WIDGET_SPACING 10

@interface ProfileViewController () <ProfileWidgetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    // PopUps
    BOOL popupAnimating;
    RKPopup *currentPopup;
    CGFloat keyboardHeight;
    
    // Make Sure the Gradient is loaded only once
    BOOL didLayoutSubviews;
}

// IB
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet RSLabel *headerEmailLabel;
@property (nonatomic, strong) IBOutlet UIButton *signOutButton;
@property (nonatomic, strong) IBOutlet UIButton *deleteButton;

// UI
@property (nonatomic, strong) UIView *widgetsView;
@property (nonatomic, strong) UIScrollView *scrollView;

// Widgets
@property (nonatomic, strong) NSArray *widgets;

@property (nonatomic, strong) RiderInfoWidget *riderInfoWidget;
@property (nonatomic, strong) AccountWidget *accountWidget;
@property (nonatomic, strong) ReceiptsWidget *receiptWidget;
@property (nonatomic, strong) ContactSupportWidget *supportWidget;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    didLayoutSubviews = NO;
    
    // Subscribe to Profile Updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutWidgets) name:RS_PROFILE_UPDATE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLayoutForReceiptsWidget) name:TRIP_NOTIFICATION_RECEIPTS_DID_UPDATE object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set up the Main View
    [self.mainView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.mainView.frame.size.height)];
    
    // These are things that we have to Layout AFTER our Main View has been dunamically re-sized by the phone, but that we only want to happen *once*, and not every time the view appears
    // This is ust a really frelling klugey way to do this, but let's Punch it, Chewey!
    if ( !didLayoutSubviews ) {
        [self setupHeaderInfo];
        [self setupWidgets];
        didLayoutSubviews = YES;
    }
    [MintManager splunkWithString:(HUB_SCREEN_SHOWN) event:YES breadcrumb:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillTransitionOntoScreen {
    [self.receiptWidget setNumberOfReceiptsShown:3];
    [self updateLayoutForReceiptsWidget];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - Setup

- (void)setupHeaderInfo {
    RSProfile *tmpProfile = [RSProfileManager sharedManager].profile;

    // Set up the Header Label
    self.headerEmailLabel.text = (tmpProfile.fullname) ? tmpProfile.fullname : tmpProfile.phoneNumber;
    [self.headerEmailLabel setTextColor:RIDESCOUT_LIGHT_GREY];

    // Set Up the Sign Out Button
    [self.signOutButton setTitleColor:BCYCLE_BLUE forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:BCYCLE_BLUE forState:UIControlStateNormal];
    
    if ( tmpProfile.image ) {
        UIImage *image = [UIImage circularScaleNCrop:tmpProfile.image scaledToRect:self.profileImageView.frame];
        if (image){
            self.profileImageView.image = image;
#pragma warning - check if rotation data is being pulled when saving the image as a .png file
            self.profileImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }
}

- (void)setupWidgets {
    [self.widgetsView removeFromSuperview];
    
    self.widgetsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    [self setUpHeaderView];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    
    // Set up the Widgets
    NSMutableArray *widgets = [[NSMutableArray alloc] init];
    
    self.riderInfoWidget = [[RiderInfoWidget alloc] initWithWidth:self.mainView.frame.size.width];
    self.riderInfoWidget.delegate = self;
    self.riderInfoWidget.containterScrollView = self.scrollView;
    [widgets addObject:self.riderInfoWidget];
    [self.widgetsView addSubview:self.riderInfoWidget];
    
    self.accountWidget = [[AccountWidget alloc] initWithWidth:self.mainView.frame.size.width];
    self.accountWidget.delegate = self;
    self.accountWidget.containterScrollView = self.scrollView;
    [widgets addObject:self.accountWidget];
    [self.widgetsView addSubview:self.accountWidget];
    
    self.receiptWidget = [[ReceiptsWidget alloc] initWithWidth:self.mainView.frame.size.width];
    self.receiptWidget.delegate = self;
    self.receiptWidget.containterScrollView = self.scrollView;
    [widgets addObject:self.receiptWidget];
    [self.widgetsView addSubview:self.receiptWidget];
    
    self.supportWidget = [[ContactSupportWidget alloc] initWithWidth:self.mainView.frame.size.width];
    self.supportWidget.delegate = self;
    self.supportWidget.containterScrollView = self.scrollView;
    [widgets addObject:self.supportWidget];
    [self.widgetsView addSubview:self.supportWidget];
    
    self.widgets = [NSArray arrayWithArray:widgets];
    
    [self layoutWidgets];
    
    // Set Up the Scroll View
    self.scrollView.contentSize = self.widgetsView.frame.size;
    [self.scrollView addSubview:self.widgetsView];
    [self.mainView addSubview:self.scrollView];
}

- (void)setUpHeaderView {
    [self.headerView removeFromSuperview];
    
    // Dynamically Re-Arrange the Header View based on current screen Size
    CGRect headerOldFrame = self.headerView.frame;
    self.headerView.frame = CGRectMake(headerOldFrame.origin.x, headerOldFrame.origin.y, self.mainView.frame.size.width, headerOldFrame.size.height);
    
    [self.widgetsView addSubview:self.headerView];
}

#pragma mark - UI

- (void)layoutWidgets {
    CGFloat contentOffset = self.headerView.frame.origin.y + self.headerView.frame.size.height + WIDGET_SPACING;
    for (ProfileWidget *widget in self.widgets) {
        [widget reload];
        CGRect frame = widget.frame;
        [widget setFrame:CGRectMake(0, contentOffset, frame.size.width, frame.size.height)];
        contentOffset += frame.size.height + WIDGET_SPACING;
    }
    contentOffset = (contentOffset > self.mainView.frame.size.height) ? contentOffset : self.mainView.frame.size.height;
    CGRect frame = self.widgetsView.frame;
    [self.widgetsView setFrame:CGRectMake(frame.origin.x, frame.origin.y,self.mainView.frame.size.width, contentOffset + 10)];
}

- (void)updateLayoutForReceiptsWidget {
    CGPoint oldOffset = self.scrollView.contentOffset;
    [self layoutWidgets];
    self.scrollView.contentSize = self.widgetsView.frame.size;
    [self.scrollView setContentOffset:oldOffset];
}

#pragma mark - Actions

- (IBAction)signOutButtonPressed:(id)sender {
    [[RKManager sharedService] logoutWithSuccess:^{
        // Access the App Delegate
        __weak AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

        // Reset the Navigaiton Controller to the Beginning
        appDelegate.navController = [[UINavigationController alloc] init];
        [appDelegate.navController setNavigationBarHidden:YES];
        LaunchViewController *vc = [[LaunchViewController alloc] init];
        [[RKManager sharedService] getNewProfile];
        [appDelegate.navController pushViewController:vc animated:NO];
        
        // Replace the Root View Controller
        [appDelegate.window setRootViewController:appDelegate.navController];
    } failure:nil];
    [MintManager splunkWithString:(HUB_BUTTON_PRESS @"Signed Out") event:YES breadcrumb:YES];
}

- (IBAction)deleteButtonPressed:(id)sender {
    
    [[RSProfileManager sharedManager] deleteProfileWithSuccess:^{
        // Access the App Delegate
        __weak AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        // Reset the Navigaiton Controller to the Beginning
        appDelegate.navController = [[UINavigationController alloc] init];
        [appDelegate.navController setNavigationBarHidden:YES];
        LaunchViewController *vc = [[LaunchViewController alloc] init];
        [[RKManager sharedService] getNewProfile];
        [appDelegate.navController pushViewController:vc animated:NO];
        
        // Replace the Root View Controller
        [appDelegate.window setRootViewController:appDelegate.navController];
    } failure:^{
        
    }];
    [MintManager splunkWithString:(HUB_BUTTON_PRESS @"Deleted!!!") event:YES breadcrumb:YES];
}

- (IBAction)profileImageViewPressed:(id)sender {
    self.tapGesture.enabled = NO;
    self.swipeGesture.enabled = NO;
    self.profileButton.enabled = NO;
    
    __weak __typeof(self) weakSelf = self;
    RSActionSheet *photoPickerSheet = [[RSActionSheet alloc] initWithTitle:nil callback:^(RSActionSheet *actionSheet, NSInteger buttonIndex) {
        weakSelf.tapGesture.enabled = YES;
        weakSelf.swipeGesture.enabled = YES;
        self.profileButton.enabled = YES;
        
        if (buttonIndex == 2) return;
            
        if (buttonIndex == 0) {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            if (status == ALAuthorizationStatusDenied) {
                RSAlertView *permissionAlert = [[RSAlertView alloc] initWithTitle:@"Permission Denied" message:@"Please go to your settings and allow RideScout to access your photo library in order to select a profile picture." placeHolder:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [permissionAlert show];
            }
            else {
                UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
                [imagePickerVC setDelegate:weakSelf];
                [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imagePickerVC setAllowsEditing:YES];
                [self presentViewController:imagePickerVC animated:YES completion:nil];
            }
        }
        else if (buttonIndex == 1) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == ALAuthorizationStatusDenied) {
                RSAlertView *permissionAlert = [[RSAlertView alloc] initWithTitle:@"Permission Denied" message:@"Please go to your settings and allow RideScout to access your camera in order to take a new profile picture." placeHolder:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [permissionAlert show];
            }
            else {
                UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
                [imagePickerVC setDelegate:weakSelf];
                [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
                [imagePickerVC setAllowsEditing:YES];
                [self presentViewController:imagePickerVC animated:YES completion:nil];
            }
        }
    } cancelButtonTitle:@"Cancel" otherButtonTitlesArray:[NSArray arrayWithObjects:@"Photo Library", @"Take Photo", nil]];
//    [photoPickerSheet showInView:self.view withHorizontalOffset:SCREEN_WIDTH - self.view.frame.size.width];
    [photoPickerSheet showInView:self.view];

    [MintManager splunkWithString:(HUB_BUTTON_PRESS @"Profile Image") event:YES breadcrumb:YES];
    
    
    // MINT
    [MintManager splunkWithString:(HUB_BUTTON_PRESS @"Profile Image") event:YES breadcrumb:YES];
}

#pragma mark - Keyboard Notifications

- (void)keyboardDidShow:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameValue = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardHeight = ((CGRect)[keyboardFrameValue CGRectValue]).size.height;
}

#pragma mark - ProfileWidgetDelegate

- (void)scrollViewLayoutNeedsUpdate {
    [self layoutWidgets];
    [self.scrollView setContentSize:self.widgetsView.frame.size];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent {
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

- (void)dismissViewController:(UIViewController *)viewControllerToDismiss {
    [viewControllerToDismiss dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePicker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    CGRect rect = [[info objectForKey:@"UIImagePickerControllerCropRect"]CGRectValue];
    CGImageRef imageRef = CGImageCreateWithImageInRect([originalImage CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.profileImage = originalImage;
    self.profileImageView.image = [UIImage circularScaleNCrop:self.profileImage scaledToRect:self.profileImageView.frame];
    
    [[RKManager sharedService] updateProfileImage:croppedImage withSuccess:^{
        

    } failure:^{
        
    }];
}

@end
