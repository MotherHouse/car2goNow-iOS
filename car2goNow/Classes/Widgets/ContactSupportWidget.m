//
//  ContactSupportWidget.m
//  RideScout
//
//  Created by Charlie Cliff on 9/1/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "ContactSupportWidget.h"
#import "RSActionSheet.h"

#import "constantsAndMacros.h"
#import "messageCopy.h"

#import <MessageUI/MessageUI.h>

@interface ContactSupportWidget () <MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) MFMailComposeViewController *mc;

@end

@implementation ContactSupportWidget

#pragma mark - Layout

- (void)buildView {
    [super buildView];
    
    // Header
    [self.headerLabel setText:CONTACT_SUPPORT_WIDGET_TITLE];
    [self.headerLabel setTextColor:BCYCLE_BLUE];
    [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
    [self.headerLabel setUserInteractionEnabled:YES];
    [self.headerLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContactSupportButton)]];
    
    // Separator
    [self.separatorLine removeFromSuperview];
    
    // Table View
    [self.tableView removeFromSuperview];
}

#pragma mark - Actions

- (void)tapContactSupportButton {
    [self presentSupportActionSheet];
}

- (void)callSupport {
    NSString *phoneNumberURL = [@"telprompt://" stringByAppendingString:CONTACT_SUPPORT_PHONE_NUMBER];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberURL]];
}

- (void)emailSupport {
    NSArray *toRecipents = [NSArray arrayWithObject:CONTACT_SUPPORT_EMAIL_ADDRESS];
    
    self.mc = [[MFMailComposeViewController alloc] init];
    self.mc.mailComposeDelegate = self;
    [self.mc setSubject:@"BCYCLE!!!"];
    //    [mc setMessageBody:messageBody isHTML:NO];
    [self.mc setToRecipients:toRecipents];
    [self.delegate presentViewController:self.mc];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self.delegate dismissViewController:self.mc];
}

- (void)presentSupportActionSheet {
    __block __weak __typeof(self)blockSelf = self;
    RSActionSheet *photoPickerSheet = [[RSActionSheet alloc] initWithTitle:nil callback:^(RSActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 2) return;
        if (buttonIndex == 0) {
            [blockSelf callSupport];
        }
        else if (buttonIndex == 1) {
            [blockSelf emailSupport];
        }
    } cancelButtonTitle:@"Cancel" otherButtonTitlesArray:[NSArray arrayWithObjects:@"Phone Support", @"Email Support", nil]];
    [photoPickerSheet showInView:self];
}
@end
