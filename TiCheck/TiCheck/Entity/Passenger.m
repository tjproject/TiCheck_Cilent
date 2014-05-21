//
//  Passenger.m
//  Test
//
//  Created by Boyi on 3/11/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Passenger.h"
#import "NSDate-Utilities.h"

@implementation Passenger

@synthesize contact = _contact;

- (id)init
{
    if (self = [super init]) {
        _passengerName = _passengerNamePY = _cardTypeName = _passportNumber = _contactTelephone = _nationalityCode = _nationalityName = _corpEid = @"";
    }
    
    return  self;
}

+ (Passenger *)passengerWithPassengerName:(NSString *)name
                                 birthDay:(NSDate *)birthday
                             passportType:(PassportType)passportType
                               passportNo:(NSString *)passportNumber
{
    Passenger *passenger = [[Passenger alloc] init];
    
    passenger.passengerName = name;
    passenger.birthDay = birthday;
    passenger.passportType = passportType;
    passenger.passportNumber = passportNumber;
    
    return passenger;
}

- (Contact *)contact
{
    if (_contact == nil) {
        _contact = [[Contact alloc] init];
        _contact.contactName = self.passengerName;
        _contact.confirmOption = self.confirmOption;
        _contact.mobilePhone = self.mobilePhone;
        _contact.contactTel = self.contactTel;
        _contact.foreignMobile = self.foreignMobile;
        _contact.mobileCountryFix = self.mobileCountryFix;
        _contact.contactEmail = self.contactEmail;
        _contact.contactFax = self.contactFax;
    }
    return _contact;
}

@end
