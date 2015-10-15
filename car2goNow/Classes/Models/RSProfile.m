//
//  RSProfile.m
//  RideScout
//
//  Created by Charlie Cliff on 9/24/15.
//  Copyright © 2015 RideScout. All rights reserved.
//

#import "RSProfile.h"

@implementation RSProfile

- (instancetype)initWithDictionary:(NSDictionary *)profileDictionary {
    self = [super initWithDictionary:profileDictionary];
    if (self) {
        [self parseRideScoutDictionary:profileDictionary];
    }
    return self;
}

#pragma mark - RideScout Profile Dictionaries

- (void)parseRideScoutDictionary:(NSDictionary *)profileDictionary {
    
    self.homeAddress = [profileDictionary stringForKey:@"home_address"];
    self.workAddress = [profileDictionary stringForKey:@"work_address"];
    
    // BCycle Account Data
    self.bCycleID = [[profileDictionary numberForKey:@"bcycle_id"] integerValue];
}


- (void)parseReservationDictionary:(NSDictionary *)reservationDict{
    
}

- (void)parseTicketDictionary:(NSDictionary *)ticketDict{
    
}

- (void)parseTripDictionary:(NSDictionary *)tripDict{
    
}

@end
