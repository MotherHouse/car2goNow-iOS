//
//  TermsOfServicePopup.m
//  RideScout
//
//  Created by Brady Miller on 9/11/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "TermsOfServicePopup.h"
#import "constantsAndMacros.h"
#import "AFNetworking.h"
#import <RideKit/NSDictionary+RKParser.h>

#define XPADDING 50
#define YPADDING 50

@interface TermsOfServicePopup () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *termsOfServiceWebView;
@property (nonatomic, strong) NSURL *url;

@end

@implementation TermsOfServicePopup

- (instancetype)initWithTermsOfServiceURL:(NSURL *)url {
    self = [super initWithFrame:CGRectMake(SCREEN_WIDTH * 0.10, SCREEN_HEIGHT * 0.08, SCREEN_WIDTH * 0.80, SCREEN_HEIGHT * 0.84)];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)buildView {
    [super buildView];
    [self.headerLabel setText:@"Terms of Service"];
    
    // Container View
    [self.containerView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.headerSeparatorImageView setFrame:CGRectMake(self.headerSeparatorImageView.frame.origin.x, self.headerSeparatorImageView.frame.origin.y, self.containerView.frame.size.width, self.headerSeparatorImageView.frame.size.height)];
    
    self.termsOfServiceWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, POPUP_DEFAULT_HEADER_HEIGHT, self.frame.size.width, self.frame.size.height - POPUP_DEFAULT_HEADER_HEIGHT - 44)];
    self.termsOfServiceWebView.delegate = self;
    [self.termsOfServiceWebView setDataDetectorTypes:UIDataDetectorTypeNone];
    [self.containerView addSubview:self.termsOfServiceWebView];
    
    UITapGestureRecognizer *youCannotTapThisView = [[UITapGestureRecognizer alloc] init];
    [self.termsOfServiceWebView addGestureRecognizer:youCannotTapThisView];
    
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.termsOfServiceWebView.frame.origin.y + self.termsOfServiceWebView.frame.size.height, self.frame.size.width, 44)];
    [acceptButton setTitleColor:BCYCLE_DARK_GREY forState:UIControlStateNormal];
    [acceptButton setTitle:@"I agree" forState:UIControlStateNormal];
    [acceptButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:17.0]];
    [acceptButton addTarget:self action:@selector(acceptTOS) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:acceptButton];
    
    UIImageView *buttonSeparatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.termsOfServiceWebView.frame.origin.y + self.termsOfServiceWebView.frame.size.height, self.containerView.frame.size.width, POPUP_DEFAULT_SEPEARATOR_WIDTH)];
    [buttonSeparatorImageView setBackgroundColor:COOPER_GRAY];
    [self.containerView addSubview:buttonSeparatorImageView];
    
    [self addSubview:self.containerView];
}

- (void)acceptTOS {
    [self closePopupCompletion:^{
        
    }];
}

- (void)loadHtml {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    __weak __typeof__(self) weakSelf = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        NSString *htmlString = [JSON stringForKey:@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.termsOfServiceWebView loadHTMLString:htmlString baseURL:nil];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operation start];
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self loadHtml];
}

@end
