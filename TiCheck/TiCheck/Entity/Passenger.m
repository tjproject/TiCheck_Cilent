//
//  Passenger.m
//  Test
//
//  Created by Boyi on 3/11/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Passenger.h"
#import "NSDate-Utilities.h"
#import "NSString+DateFormat.h"
#import "UserData.h"
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
    
    //默认国籍：中国
    passenger.nationalityCode = @"1";
    return passenger;
}

+ (Passenger *)createPassengerWithDictionary:(NSDictionary *)dictionary
{
    Passenger *result = [[Passenger alloc] init];
    result.passengerName = dictionary[@"passengerName"];
    @try
    {
        result.birthDay = [NSString timeFormatWithString:dictionary[@"birthDay"]];
    }
    @catch(NSException * exception)
    {
        //
    }
    result.passportType = [dictionary[@"passportType"] integerValue];
    result.passportNumber = dictionary[@"passportNumber"];
    result.contactTelephone = dictionary[@"contactTelephone"];
    result.gender = [dictionary[@"gender"] integerValue];
    result.nationalityCode = @"1";
    return result;
}

+ (Passenger *)createPassengerByServerData:(NSDictionary *)dictionary
{
    Passenger *result = [[Passenger alloc] init];
    result.passengerName = dictionary[SERVER_NAME_KEY];
    @try
    {
        result.birthDay = [NSString timeFormatWithString:dictionary[SERVER_BIRTHDAY_KEY]];
    }
    @catch(NSException * exception)
    {
        //
    }
    result.passportType = [dictionary[SERVER_PASSPORTTYPE_KEY] integerValue];
    result.passportNumber = dictionary[SERVER_PASSPORTNUMBER_KEY];
    result.contactTelephone = dictionary[SERVER_TELPHONE_KEY];
    result.gender = [dictionary[SERVER_GENDER_KEY] integerValue];
    result.nationalityCode = @"1";
    return result;
}


- (NSDictionary *)dictionaryWithPassengerOption
{
    NSMutableDictionary *contactDictionary = [NSMutableDictionary dictionary];
    
    [contactDictionary setObject:self.passengerName forKey:SERVER_NAME_KEY];
    [contactDictionary setObject:[NSString stringFormatWithDate:self.birthDay] forKey:SERVER_BIRTHDAY_KEY];
    [contactDictionary setObject:self.passportNumber forKey:SERVER_PASSPORTNUMBER_KEY];
    [contactDictionary setObject:self.contactTelephone forKey:SERVER_TELPHONE_KEY];
    
    
    [contactDictionary setObject:[NSString stringWithFormat:@"%d", self.passportType] forKey:SERVER_PASSPORTTYPE_KEY];
    [contactDictionary setObject:[NSString stringWithFormat:@"%d", self.gender] forKey:SERVER_GENDER_KEY];
    
    return contactDictionary;
}

- (Contact *)contact
{
    if (_contact == nil) {
        _contact = [[Contact alloc] init];
        _contact.contactName = self.passengerName;
        _contact.confirmOption = EML;
        _contact.mobilePhone = self.contactTelephone;
        //_contact.contactTel = self.contactTelephone;
        //_contact.foreignMobile = self.foreignMobile;
        //_contact.mobileCountryFix = self.mobileCountryFix;
        _contact.contactEmail = [UserData sharedUserData].email;
        //_contact.contactFax = self.contactFax;
    }
    return _contact;
}

@end
