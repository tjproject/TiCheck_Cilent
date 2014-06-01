//
//  Passenger.m
//  TiCheck
//
//  Created by Boyi on 6/1/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "Passenger.h"
#import "Contact.h"
#import "UserData.h"
#import "EnumCollection.h"
#import "NSString+DateFormat.h"
#import <CoreData+MagicalRecord.h>

@implementation Passenger

@synthesize contact = _contact;

@dynamic passengerName;
@dynamic passengerNamePY;
@dynamic birthDay;
@dynamic passportType;
@dynamic cardTypeName;
@dynamic passportNumber;
@dynamic contactTelephone;
@dynamic gender;
@dynamic nationalityCode;
@dynamic nationalityName;
@dynamic cardValid;
@dynamic corpEid;

+ (Passenger *)passengerWithPassengerName:(NSString *)name
                                 birthday:(NSDate *)birthday
                             passportType:(PassportType)passportType
                               passportNo:(NSString *)passportNumber
{
    Passenger *passenger = [Passenger MR_createEntity];
    
    passenger.passengerName = name;
    passenger.birthDay = birthday;
    passenger.passportType = [NSNumber numberWithInt:passportType];
    passenger.passportNumber = passportNumber;
    
    // 默认国籍：中国
    passenger.nationalityCode = @"1";
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    return  passenger;
}

+ (Passenger *)createPassengerWithDictionary:(NSDictionary *)dictionary
{
    Passenger *passenger = [Passenger MR_createEntity];
    
    passenger.passengerName = dictionary[@"passengerName"];
    @try
    {
        passenger.birthDay = [NSString timeFormatWithString:dictionary[@"birthDay"]];
    }
    @catch(NSException * exception)
    {
        //
    }
    passenger.passportType = [NSNumber numberWithInteger:[dictionary[@"passportType"] integerValue]];
    passenger.passportNumber = dictionary[@"passportNumber"];
    passenger.contactTelephone = dictionary[@"contactTelephone"];
    passenger.gender = [NSNumber numberWithInteger:[dictionary[@"gender"] integerValue]];
    passenger.nationalityCode = @"1";
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    return passenger;
}

+ (Passenger *)createPassengerByServerData:(NSDictionary *)dictionary
{
    Passenger *result = [Passenger MR_createEntity];
    result.passengerName = dictionary[SERVER_NAME_KEY];
    @try
    {
        result.birthDay = [NSString timeFormatWithString:dictionary[SERVER_BIRTHDAY_KEY]];
    }
    @catch(NSException * exception)
    {
        //
    }
    
    result.passportType = [NSNumber numberWithInt:[dictionary[SERVER_PASSPORTTYPE_KEY] integerValue]];
    result.passportNumber = dictionary[SERVER_PASSPORTNUMBER_KEY];
    result.contactTelephone = dictionary[SERVER_TELPHONE_KEY];
    result.gender = [NSNumber numberWithInt:[dictionary[SERVER_GENDER_KEY] integerValue]];
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
    
    
    [contactDictionary setObject:[NSString stringWithFormat:@"%@", self.passportType] forKey:SERVER_PASSPORTTYPE_KEY];
    [contactDictionary setObject:[NSString stringWithFormat:@"%@", self.gender] forKey:SERVER_GENDER_KEY];
    
    return contactDictionary;
}

+ (Passenger *)findPassengerWithPassengerName:(NSString *)name
{
    return [Passenger MR_findFirstByAttribute:@"passengerName" withValue:name];
}

+ (NSArray *)findAllPassengers
{
    return [Passenger MR_findAllSortedBy:@"passengerName" ascending:YES];
}

+ (void)deleteAllPassengers
{
    [Passenger MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)savePassenger
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)deletePassenger
{
    [self MR_deleteEntity];
}

- (Contact *)contact
{
    if (_contact == nil) {
        _contact = [[Contact alloc] init];
        _contact.contactName = self.passengerName;
        _contact.confirmOption = EML;
        _contact.mobilePhone = self.contactTelephone;
        _contact.contactEmail = [UserData sharedUserData].email;
    }
    
    return _contact;
}

@end
