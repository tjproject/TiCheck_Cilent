//
//  Flight.m
//  Test
//
//  Created by Boyi on 3/5/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Flight.h"
#import "DomesticCity.h"
#import "APIResourceHelper.h"

@implementation Flight

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

@end
