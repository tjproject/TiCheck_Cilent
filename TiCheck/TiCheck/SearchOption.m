//
//  SearchOption.m
//  TiCheck
//
//  Created by Boyi on 4/21/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "SearchOption.h"
#import "NSDate-Utilities.h"

#define DEPART_CITY_KEY @"departCityName"
#define ARRIVE_CITY_KEY @"arriveCityName"
#define TAKE_OFF_DATE_KEY @"takeOffDate"
#define RETURN_DATE_KEKY @"returnDate"

@implementation SearchOption

+ (SearchOption *)sharedSearchOption
{
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedSearchOption = nil;
    dispatch_once(&onceToken, ^{
        _sharedSearchOption = [[self alloc] initWithDefaultOption];
    });;
    return _sharedSearchOption;
}

- (id)initWithDefaultOption
{
    if (self = [super init]) {
        if (self.departCityName == nil || [self.departCityName isEqualToString:@""]) {
            self.departCityName = @"上海";
            self.arriveCityName = @"北京";
            self.takeOffDate = [NSDate date];
            self.returnDate = [NSDate dateTomorrow];
        }
    }
    
    return self;
}

- (void)setDepartCityName:(NSString *)departCityName
{
    [[NSUserDefaults standardUserDefaults] setObject:departCityName forKey:DEPART_CITY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setArriveCityName:(NSString *)arriveCityName
{
    [[NSUserDefaults standardUserDefaults] setObject:arriveCityName forKey:ARRIVE_CITY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTakeOffDate:(NSDate *)takeOffDate
{
    [[NSUserDefaults standardUserDefaults] setObject:takeOffDate forKey:TAKE_OFF_DATE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setReturnDate:(NSDate *)returnDate
{
    [[NSUserDefaults standardUserDefaults] setObject:returnDate forKey:RETURN_DATE_KEKY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)departCityName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DEPART_CITY_KEY];
}

- (NSString *)arriveCityName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ARRIVE_CITY_KEY];
}

- (NSDate *)takeOffDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:TAKE_OFF_DATE_KEY];
}

- (NSDate *)returnDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:RETURN_DATE_KEKY];
}

@end
