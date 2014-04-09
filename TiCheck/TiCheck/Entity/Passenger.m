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

@end
