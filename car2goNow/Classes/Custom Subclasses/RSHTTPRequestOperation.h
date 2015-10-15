//
//  RSHTTPRequestOperation.h
//  Bcycle
//
//  Created by Jason Dimitriou on 10/12/15.
//  Copyright © 2015 ridescout. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface RSHTTPRequestOperation : AFHTTPRequestOperation

/**
 Whether request operations should retry the request upon failure. Popup with try again and okay. `YES` by default.
 
 @see AFURLConnectionOperation -shouldUseCredentialStorage
 */
@property (nonatomic, assign) BOOL shouldTryAgainUponFailure;

@end
