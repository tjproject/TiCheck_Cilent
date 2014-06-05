//
//  Subscription.m
//  TiCheck
//
//  Created by Boyi on 4/29/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "Subscription.h"
#import "APIResourceHelper.h"

#import "DomesticCity.h"
#import "Airline.h"
#import "Airport.h"

#import "NSString+DateFormat.h"

@interface Subscription ()

@property (nonatomic, strong, readwrite) NSNumber *ID;
@property (nonatomic, strong, readwrite) DomesticCity *departCity;
@property (nonatomic, strong, readwrite) DomesticCity *arriveCity;
@property (nonatomic, strong, readwrite) NSDate *startDate;
@property (nonatomic, strong, readwrite) NSDate *endDate;
@property (nonatomic, strong, readwrite) NSString *earliestDepartTime;
@property (nonatomic, strong, readwrite) NSString *latestDepartTime;
@property (nonatomic, strong, readwrite) Airline *airline;
@property (nonatomic, strong, readwrite) Airport *arriveAirport;
@property (nonatomic, strong, readwrite) Airport *departAirport;

@end

@implementation Subscription

- (id)initWithDepartCity:(NSString *)departCityName
              arriveCity:(NSString *)arriveCityName
               startDate:(NSString *)startDateStr
                 endDate:(NSString *)endDateStr
{
    if (self = [super init]) {
        self.departCity         = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:departCityName];
        self.arriveCity         = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:arriveCityName];
        self.startDate          = [NSString dateFormatWithString:startDateStr];
        self.endDate            = [NSString dateFormatWithString:endDateStr];

        self.earliestDepartTime = @"";
        self.latestDepartTime   = @"";
        self.airline            = nil;
        self.arriveAirport      = nil;
        self.departAirport      = nil;
    }
    
    return self;
}

- (id)initWithDepartCityCode:(NSString *)departCityCode
              arriveCityCode:(NSString *)arriveCityCode
                   startDate:(NSString *)startDateStr
                     endDate:(NSString *)endDateStr
                    idNumber:(NSNumber *)nsnumber_id
{
    if (self = [super init]) {
        self.ID                 = nsnumber_id;
        self.departCity         = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaCode:departCityCode];
        self.arriveCity         = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaCode:arriveCityCode];
        self.startDate          = [NSString dateFormatWithString:startDateStr];
        self.endDate            = [NSString dateFormatWithString:endDateStr];
        
        self.earliestDepartTime = @"";
        self.latestDepartTime   = @"";
        self.airline            = nil;
        self.arriveAirport      = nil;
        self.departAirport      = nil;
    }
    
    return self;
}


- (void)modifyMoreOptionWithEarliestDepartTime:(NSString *)earliestDepartTime
                              LatestDepartTime:(NSString *)latestDepartTime
                              airlineShortName:(NSString *)airlineShortName
                             arriveAirportName:(NSString *)arriveAirportName
                             departAirportName:(NSString *)departAirportName
{
    self.earliestDepartTime = earliestDepartTime;
    self.latestDepartTime   = latestDepartTime;
    self.airline            = [[APIResourceHelper sharedResourceHelper] findAirlineViaAirlineShortName:airlineShortName];
    self.arriveAirport      = [[APIResourceHelper sharedResourceHelper] findAirportViaName:arriveAirportName];
    self.departAirport      = [[APIResourceHelper sharedResourceHelper] findAirportViaName:departAirportName];
}

- (NSDictionary *)dictionaryWithSubscriptionOption
{
    NSMutableDictionary *subscriptionDictionary = [NSMutableDictionary dictionary];
    
//    [subscriptionDictionary setObject:self.ID forKey:SERVER_ID_KEY];
    [subscriptionDictionary setObject:self.departCity.cityCode forKey:SERVER_DEPART_CITY_KEY];
    [subscriptionDictionary setObject:self.arriveCity.cityCode forKey:SERVER_ARRIVE_CITY_KEY];
    [subscriptionDictionary setObject:[NSString stringFormatWithDate:self.startDate] forKey:SERVER_START_DATE_KEY];
    [subscriptionDictionary setObject:[NSString stringFormatWithDate:self.endDate] forKey:SERVER_END_DATE_KEY];
    
    [subscriptionDictionary setObject:self.earliestDepartTime forKey:SERVER_EARLIEST_DEPART_TIME_KEY];
    [subscriptionDictionary setObject:self.latestDepartTime forKey:SERVER_LATEST_DEPART_TIME_KEY];
    [subscriptionDictionary setObject:(self.airline == nil ? @"" : self.airline.airline) forKey:SERVER_AIRLINE_DIBIT_CODE_KEY];
    [subscriptionDictionary setObject:(self.arriveAirport == nil ? @"" : self.arriveAirport.airportCode) forKey:SERVER_DEPART_AIRPORT_KEY];
    [subscriptionDictionary setObject:(self.departAirport == nil ? @"" : self.departAirport.airportCode) forKey:SERVER_ARRIVE_AIRPORT_KEY];
    
    return subscriptionDictionary;
}

@end
