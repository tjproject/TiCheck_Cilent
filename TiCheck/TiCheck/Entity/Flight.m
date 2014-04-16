//
//  Flight.m
//  Test
//
//  Created by Boyi on 3/5/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Flight.h"
#import "DomesticCity.h"
#import "Airport.h"
#import "APIResourceHelper.h"

@implementation Flight

#pragma mark - Setter

#pragma mark City Setter

- (void)setDepartCityID:(NSInteger)departCityID
{
    DomesticCity *targetCity = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaID:departCityID];
    [self updateDepartCityInfo:targetCity];
}

- (void)setDepartCityCode:(NSString *)departCityCode
{
    DomesticCity *targetCity = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaCode:departCityCode];
    [self updateDepartCityInfo:targetCity];
}

- (void)setDepartCityName:(NSString *)departCityName
{
    DomesticCity *targetCity = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:departCityName];
    [self updateDepartCityInfo:targetCity];
}

- (void)setArriveCityID:(NSInteger)arriveCityID
{
    DomesticCity *targetCity = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaID:arriveCityID];
    [self updateArriveCityInfo:targetCity];
}

- (void)setArriveCityCode:(NSString *)arriveCityCode
{
    DomesticCity *targetCity = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaCode:arriveCityCode];
    [self updateArriveCityInfo:targetCity];
}

- (void)setArriveCityName:(NSString *)arriveCityName
{
    DomesticCity *targetCity = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:arriveCityName];
    [self updateArriveCityInfo:targetCity];
}

#pragma mark Airport Setter

- (void)setDepartPortCode:(NSString *)departPortCode
{
    Airport *targetAirport = [[APIResourceHelper sharedResourceHelper] findAirportViaCode:departPortCode];
    [self updateDepartPortInfo:targetAirport];
}

- (void)setDepartPortName:(NSString *)departPortName
{
    Airport *targetAirport = [[APIResourceHelper sharedResourceHelper] findAirportViaName:departPortName];
    [self updateDepartPortInfo:targetAirport];
}

- (void)setArrivePortCode:(NSString *)arrivePortCode
{
    Airport *targetAirport = [[APIResourceHelper sharedResourceHelper] findAirportViaCode:arrivePortCode];
    [self updateArrivePortInfo:targetAirport];
}

- (void)setArrivePortName:(NSString *)arrivePortName
{
    Airport *targetAirport = [[APIResourceHelper sharedResourceHelper] findAirportViaName:arrivePortName];
    [self updateArrivePortInfo:targetAirport];
}

#pragma mark - Helper Methods

- (void)updateDepartCityInfo:(DomesticCity *)city
{
    _departCityID   = city.cityID;
    _departCityCode = city.cityCode;
    _departCityName = city.cityName;
}

- (void)updateArriveCityInfo:(DomesticCity *)city
{
    _arriveCityID   = city.cityID;
    _arriveCityCode = city.cityCode;
    _arriveCityName = city.cityName;
}

- (void)updateDepartPortInfo:(Airport *)airport
{
    _departPortCode      = airport.airportCode;
    _departPortName      = airport.airportName;
    _departPortShortName = airport.airportShortName;
}

- (void)updateArrivePortInfo:(Airport *)airport
{
    _arrivePortCode      = airport.airportCode;
    _arrivePortName      = airport.airportName;
    _arrivePortShortName = airport.airportShortName;
}

@end
