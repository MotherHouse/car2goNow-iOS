//
//  QuesitonPopup.m
//  RideScout
//
//  Created by Charlie Cliff on 7/8/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "QuestionPopup.h"
#import "constantsAndMacros.h"

#define TEXTFIELD_HEIGHT 30.0
#define QUESTION_POPUP_WIDTH SCREEN_WIDTH*.8
#define ENTER_TEXT_POPUP_HEIGHT 60.0
#define EDGE_PAD 15

#define FOOTER_BUTTON_SPACING 20
#define FOOTER_BUTTON_WIDTH 60

@interface QuestionPopup ()

@property (nonatomic, strong) RSLabel *questionLabel;

@end

@implementation QuestionPopup

//@synthesize acceptedEntryBlock;

- (void)buildView {
    [super buildView];
    
    // Resize the ContainerView
    CGFloat totalHeight = 5 * POPUP_DEFAULT_HEADER_HEIGHT;
    [self.containerView setFrame:CGRectMake((self.frame.size.width-QUESTION_POPUP_WIDTH)/2, (self.frame.size.height-totalHeight)/2, QUESTION_POPUP_WIDTH, totalHeight)];
    self.containerView.clipsToBounds = YES;

    // Add the Separator Views
    [self.headerSeparatorImageView setFrame:CGRectMake(0, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, self.headerSeparatorImageView.frame.size.width, self.headerSeparatorImageView.frame.size.height)];
    self.buttonSeparatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width/2, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, POPUP_DEFAULT_LINE_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    [self.buttonSeparatorImageView setBackgroundColor:COOPER_GRAY];
    [self.containerView addSubview:self.buttonSeparatorImageView];
    
    // Set Up the Header
    [self.headerLabel setTextColor:BCYCLE_DARK_GREY];

    // Set Up Question Text
    self.questionLabel = [[RSLabel alloc] initWithFrame:CGRectMake(EDGE_PAD, POPUP_DEFAULT_HEADER_HEIGHT, self.containerView.frame.size.width - 2*EDGE_PAD, 3*POPUP_DEFAULT_HEADER_HEIGHT)];
    self.questionLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.questionLabel setFontSize:17];
    [self.questionLabel setTextColor:BCYCLE_DARK_GREY];
    [self.containerView addSubview:self.questionLabel];
    
    // Set Up Cancel Button
    CGFloat cancelLabelX = (self.containerView.frame.size.width / 4) - FOOTER_BUTTON_WIDTH / 2;
    self.cancelLabel = [[RSLabel alloc] initWithFrame:CGRectMake(cancelLabelX, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, FOOTER_BUTTON_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    self.cancelLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.cancelLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancelLabel setFontSize:17];
    [self.cancelLabel setText:@"Cancel"];
    [self.cancelLabel setTextColor:BCYCLE_LIGHT_PURPLE];
    [self.cancelLabel setBackgroundColor:[UIColor clearColor]];
    [self.cancelLabel setUserInteractionEnabled:YES];
    [self.cancelLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed)]];
    [self.containerView addSubview:self.cancelLabel];
    
    // Set Up Accept Button
    CGFloat acceptLabelX = (3*self.containerView.frame.size.width / 4) - FOOTER_BUTTON_WIDTH / 2;
    self.acceptLabel = [[RSLabel alloc] initWithFrame:CGRectMake(acceptLabelX, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, FOOTER_BUTTON_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    self.acceptLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.acceptLabel.textAlignment = NSTextAlignmentCenter;
    [self.acceptLabel setFontSize:17];
    [self.acceptLabel setText:@"OK"];
    [self.acceptLabel setTextColor:BCYCLE_LIGHT_PURPLE];
    [self.acceptLabel setBackgroundColor:[UIColor clearColor]];
    [self.acceptLabel setUserInteractionEnabled:YES];
    [self.acceptLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptButtonPressed)]];
    [self.containerView addSubview:self.acceptLabel];
}

#pragma mark - Setters

- (void)setQuestionText:(NSString *)questiontext {
    self.questionLabel.text = questiontext;
}

- (void)setCancelLabelText:(NSString *)text {
    self.cancelLabel.text = text;
}

- (void)setAcceptLabelText:(NSString *)text {
    self.acceptLabel.text = text;
}

- (void)setAcceptanceButtonHidden:(BOOL)isHidden {
    // Set the Hidden Attrbute of the ACCEPTANCE Button
    [self.acceptLabel setHidden:isHidden];
    // Display or Remove the ACCEPTANCE Button accordingly
    if ( self.acceptLabel.isHidden ) {
        // Remove the ACCEPT Button
        if ( self.acceptLabel.superview ) [self.acceptLabel removeFromSuperview];
        if ( self.buttonSeparatorImageView.superview ) [self.buttonSeparatorImageView removeFromSuperview];

        // Set Up CANCEL Button
        CGFloat cancelLabelX = (self.containerView.frame.size.width - FOOTER_BUTTON_WIDTH)  / 2;
        [self.cancelLabel setFrame:CGRectMake(cancelLabelX, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, FOOTER_BUTTON_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
    }
    if ( !self.acceptLabel.isHidden ) {
        // Set Up ACCEPT Button
        CGFloat acceptLabelX = (self.containerView.frame.size.width / 2) + FOOTER_BUTTON_WIDTH / 2;
        [self.acceptLabel setFrame:CGRectMake(acceptLabelX, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, FOOTER_BUTTON_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
        [self.acceptLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptButtonPressed)]];
        [self.containerView addSubview:self.acceptLabel];
        [self.containerView addSubview:self.buttonSeparatorImageView];

        // Set Up CANCEL Button
        CGFloat cancelLabelX = (self.containerView.frame.size.width / 2) - FOOTER_BUTTON_WIDTH - FOOTER_BUTTON_WIDTH / 2;
        [self.cancelLabel setFrame:CGRectMake(cancelLabelX, self.containerView.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT, FOOTER_BUTTON_WIDTH, POPUP_DEFAULT_HEADER_HEIGHT)];
        [self.containerView addSubview:self.cancelLabel];
    }
}

@end
