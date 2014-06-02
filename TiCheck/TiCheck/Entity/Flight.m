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
#import "Airline.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"

#import "APIResourceHelper.h"

@implementation Flight

+ (Flight *)createFilghtWithDictionary:(NSDictionary *)dictionary
{
    Flight *flight = [[Flight alloc] init];
    //dictionary[@""]
    flight.departCityCode          = dictionary[@"departCityCode"];
    flight.arriveCityCode          = dictionary[@"arriveCityCode"];
    @try {
        flight.takeOffTime             = [NSString timeFormatWithString:dictionary[@"takeOffTime"]];
        flight.arrivalTime             = [NSString timeFormatWithString:dictionary[@"arrivalTime"]];
    }
    @catch (NSException *exception) {
        //
    }
    flight.flightNumber            = dictionary[@"flightNumber"];
    flight.craftType               = dictionary[@"craftType"];
    flight.airlineDibitCode        = dictionary[@"airlineDibitCode"];
    flight.classGrade              = [dictionary[@"classGrade"] integerValue];
    flight.subClass                = dictionary[@"subClass"];
    flight.displaySubClass         = dictionary[@"displaySubClass"];
    flight.rate                    = [dictionary[@"rate"] floatValue];
    flight.price                   = [dictionary[@"price"] integerValue];
    flight.standardPrice           = [dictionary[@"standardPrice"] integerValue];
    flight.childStandardPrice      = [dictionary[@"childStandardPrice"] integerValue];
    flight.babyStandardPrice       = [dictionary[@"babyStandardPrice"] integerValue];
    flight.mealType                = dictionary[@"mealType"];
    flight.adultTax                = [dictionary[@"adultTax"] integerValue];
    flight.babyTax                 = [dictionary[@"babyTax"] integerValue];
    flight.childTax                = [dictionary[@"childTax"] integerValue];
    flight.adultOilFee             = [dictionary[@"adultOilFee"] integerValue];
    flight.babyOilFee              = [dictionary[@"babyOilFee"] integerValue];
    flight.childOilFee             = [dictionary[@"childOilFee"] integerValue];
    flight.departPortCode          = dictionary[@"departPortCode"];
    flight.arrivePortCode          = dictionary[@"arrivePortCode"];
    flight.departPortBuildingID    = [dictionary[@"departPortBuildingID"] integerValue];
    flight.arrivePortBuildingID    = [dictionary[@"arrivePortBuildingID"] integerValue];
    flight.stopTimes               = [dictionary[@"stopTimes"] integerValue];
    flight.nonRer                  = dictionary[@"nonRer"];
    flight.nonEnd                  = dictionary[@"nonEnd"];
    flight.nonRef                  = dictionary[@"nonRef"];
    flight.rerNote                 = dictionary[@"rerNote"];
    flight.endNote                 = dictionary[@"endNote"];
    flight.refNote                 = dictionary[@"refNote"];
    flight.remarks                 = dictionary[@"remarks"];
    flight.ticketType              = dictionary[@"ticketType"];
    flight.beforeFlyDate           = [dictionary[@"beforeFlyDate"] integerValue];
    flight.quantity                = [dictionary[@"quantity"] integerValue];
    flight.priceType               = [dictionary[@"priceType"] integerValue];
    flight.productType             = [dictionary[@"productType"] integerValue];
    flight.productSource           = [dictionary[@"productSource"] integerValue];
    flight.inventoryType           = [dictionary[@"inventoryType"] integerValue];
    flight.routeIndex              = [dictionary[@"routeIndex"] integerValue];
    flight.needApplyString         = [dictionary[@"needApplyString"] boolValue];
    flight.recommend               = [dictionary[@"recommend"] integerValue];
    flight.refundFeeFormulaID      = [dictionary[@"refundFeeFormulaID"] integerValue];
    flight.canUpGrade              = [dictionary[@"canUpGrade"] boolValue];
    flight.canSeparateSale         = dictionary[@"canSeparateSale"];
    flight.canNoDefer              = [dictionary[@"canNoDefer"] boolValue];
    flight.isFlyMan                = [dictionary[@"isFlyMan"] boolValue];
    flight.onlyOwnCity             = [dictionary[@"onlyOwnCity"] boolValue];
    flight.isLowestPrice           = [dictionary[@"isLowestPrice"] boolValue];
    flight.isLowestCZSpecialPrice  = [dictionary[@"isLowestCZSpecialPrice"] boolValue];
    flight.punctualityRate         = [dictionary[@"punctualityRate"] floatValue];
    flight.policyID                = dictionary[@"policyID"];
    flight.allowCPType             = dictionary[@"allowCPType"];
    flight.outOfPostTime           = [dictionary[@"outOfPostTime"] boolValue];
    flight.outOfSendGetTime        = [dictionary[@"outOfSendGetTime"] boolValue];
    flight.outOfAirlineCounterTime = [dictionary[@"outOfAirlineCounterTime"] boolValue];
    flight.canPost                 = [dictionary[@"canPost"] boolValue];
    flight.canAirlineCounter       = [dictionary[@"canAirlineCounter"] boolValue];
    flight.canSendGet              = [dictionary[@"canSendGet"] boolValue];
    flight.isRebate                = [dictionary[@"isRebate"] boolValue];
    flight.rebateAmount            = [dictionary[@"rebateAmount"] floatValue];
    flight.rebateCPCity            = dictionary[@"rebateCPCity"];
    
    return flight;
}



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

#pragma mark Airline Setter

- (void)setAirlineDibitCode:(NSString *)airlineDibitCode
{
    Airline *airline = [[APIResourceHelper sharedResourceHelper] findAirlineViaAirlineDibitCode:airlineDibitCode];
    [self updateAirlineInfo:airline];
}

- (void)setAirlineShortName:(NSString *)airlineShortName
{
    Airline *airline = [[APIResourceHelper sharedResourceHelper] findAirlineViaAirlineShortName:airlineShortName];
    [self updateAirlineInfo:airline];
}

- (void)setAirlineName:(NSString *)airlineName
{
    Airline *airline = [[APIResourceHelper sharedResourceHelper] findAirlineViaAirlineName:airlineName];
    [self updateAirlineInfo:airline];
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

- (void)updateAirlineInfo:(Airline *)airline
{
    _airlineDibitCode = airline.airline;
    _airlineShortName = airline.shortName;
    _airlineName      = airline.airlineName;
}

@end
