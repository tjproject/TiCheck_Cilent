//
//  APIResourceHelper.m
//  TiCheck
//
//  Created by Boyi on 4/13/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "APIResourceHelper.h"
#import "GDataXMLNode.h"

#import "Airport.h"
#import "DomesticCity.h"
#import "CraftType.h"
#import "Airline.h"

#define ObjectElementToString(object, element) [[[object elementsForName:element] firstObject] stringValue] == nil ? @"" : [[[object elementsForName:element] firstObject] stringValue]

@implementation APIResourceHelper {
    NSArray *domesticCities;    // 国内城市信息列表
    NSArray *domesticAirports;  // 国内机场信息列表
    NSArray *craftTypes;        // 机型信息列表
    NSArray *airlines;          // 航空公司列表
}

+ (APIResourceHelper *)sharedResourceHelper
{
    static dispatch_once_t pred = 0;
    __strong static APIResourceHelper *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initStaticInfo];
    });
    return _sharedObject;
}

- (id)initStaticInfo
{
    if (self = [super init]) {
        [self loadDomesticCities];
        [self loadAirports];
        [self loadCraftTypes];
        [self loadAirlines];
    }
    
    return self;
}

#pragma mark - 搜索方法
#pragma mark 国内城市搜索

- (DomesticCity *)findDomesticCityViaID:(NSInteger)cityID
{
    DomesticCity *result = nil;
    
    for (DomesticCity *city in domesticCities) {
        if (city.cityID == cityID) {
            result = city;
            break;
        }
    }
    
    return result;
}

- (DomesticCity *)findDomesticCityViaCode:(NSString *)cityCode
{
    DomesticCity *result = nil;
    
    for (DomesticCity *city in domesticCities) {
        if ([city.cityCode isEqualToString:cityCode]) {
            result = city;
            break;
        }
    }
    
    return result;
}

- (DomesticCity *)findDomesticCityViaName:(NSString *)cityName
{
    DomesticCity *result = nil;
    
    for (DomesticCity *city in domesticCities) {
        if ([city.cityName isEqualToString:cityName]) {
            result = city;
            break;
        }
    }
    
    return result;
}

- (NSArray *)findAllCityNameContainsAirport
{
    NSMutableArray *cities = [NSMutableArray array];
    
    for (DomesticCity *city in domesticCities) {
        if ([city.airports count] != 0) {
            [cities addObject:city.cityName];
        }
    }

    return cities;
}

#pragma mark 机场搜索

- (Airport *)findAirportViaCode:(NSString *)airportCode
{
    Airport *result = nil;
    
    for (Airport *airport in domesticAirports) {
        if ([airport.airportCode isEqualToString:airportCode]) {
            result = airport;
            break;
        }
    }
    
    return result;
}

- (Airport *)findAirportViaName:(NSString *)airportName
{
    Airport *result = nil;
    
    for (Airport *airport in domesticAirports) {
        if ([airport.airportName isEqualToString:airportName]) {
            result = airport;
            break;
        }
    }
    
    return result;
}

- (NSArray *)findAirportViaCityID:(NSInteger)cityID
{
    NSMutableArray *airports = [NSMutableArray array];
    
    DomesticCity *city = [self findDomesticCityViaID:cityID];
    for (NSString *airportCode in city.airports) {
        [airports addObject:[self findAirportViaCode:airportCode]];
    }
    
    return airports;
}

- (NSArray *)findAirportsNameInCity:(NSString *)cityName
{
    NSMutableArray *airports = [NSMutableArray array];
    
    NSArray *airportsCode = [self findDomesticCityViaName:cityName].airports;
    for (NSString *airportCode in airportsCode) {
        [airports addObject:[self findAirportViaCode:airportCode].airportName];
    }
    
    return airports;
}

#pragma mark 机型搜索

- (CraftType *)findCraftTypeViaCT:(NSString *)craftType
{
    CraftType *result = nil;
    
    for (CraftType *ct in craftTypes) {
        if ([ct.craftType isEqualToString:craftType]) {
            result = ct;
            break;
        }
    }
    
    return result;
}

#pragma mark 航空公司搜索

- (NSArray *)findAllAirlineShortNames
{
    NSMutableArray *allAirlineName = [NSMutableArray array];
    
    for (Airline *airline in airlines) {
        [allAirlineName addObject:airline.shortName];
    }
    
    return allAirlineName;
}

- (Airline *)findAirlineViaAirlineShortName:(NSString *)airlineShortName
{
    Airline *result = nil;
    
    for (Airline *airline in airlines) {
        if ([airline.shortName isEqualToString:airlineShortName]) {
            result = airline;
            break;
        }
    }
    
    return result;
}

#pragma mark - Helper Methods

- (void)loadDomesticCities
{
    NSString *domesticCityFile = [[NSBundle mainBundle] pathForResource:@"DomesticCities"
                                                                 ofType:@"xml"];
    NSString *domesticCityString = [NSString stringWithContentsOfFile:domesticCityFile
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
    
    GDataXMLDocument *xml = [[GDataXMLDocument alloc] initWithXMLString:domesticCityString
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];
    GDataXMLElement *root = [xml rootElement];
    
    NSArray *cityDetails = [root nodesForXPath:@"//CityDetail"
                                         error:nil];
    NSMutableArray *cityInfo = [NSMutableArray array];
    for (GDataXMLElement *cityDetail in cityDetails) {
        DomesticCity *city = [[DomesticCity alloc] init];
        
        city.cityCode   = ObjectElementToString(cityDetail, @"CityCode");
        city.cityID     = [ObjectElementToString(cityDetail, @"City") integerValue];
        city.cityName   = ObjectElementToString(cityDetail, @"CityName");
        city.cityEName  = ObjectElementToString(cityDetail, @"CityEName");
        city.countryID  = [ObjectElementToString(cityDetail, @"Country") integerValue];
        city.provinceID = [ObjectElementToString(cityDetail, @"Province") integerValue];
        
        NSString *airportsString = ObjectElementToString(cityDetail, @"Airport");
        NSMutableArray *airports = [[airportsString componentsSeparatedByString:@","] mutableCopy];
        if (!airports) airports = [@[] mutableCopy];
        if ([[airports lastObject] isEqualToString:@""]) {
            [airports removeLastObject];
        }
        
        city.airports = airports;
        
        [cityInfo addObject:city];
    }
    
    domesticCities = cityInfo;
}

- (void)loadAirports
{
    NSString *domesticAirportFile = [[NSBundle mainBundle] pathForResource:@"Airports"
                                                                    ofType:@"xml"];
    NSString *domesticAirportString = [NSString stringWithContentsOfFile:domesticAirportFile
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
    
    GDataXMLDocument *xml = [[GDataXMLDocument alloc] initWithXMLString:domesticAirportString
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];
    GDataXMLElement *root = [xml rootElement];
    
    NSArray *airportDetails = [root nodesForXPath:@"//AirportInfoEntity"
                                            error:nil];
    
    NSMutableArray *airportInfo = [NSMutableArray array];
    for (GDataXMLElement *airportDetail in airportDetails) {
        Airport *airport = [[Airport alloc] init];
        
        airport.airportCode      = ObjectElementToString(airportDetail, @"AirPort");
        airport.airportName      = ObjectElementToString(airportDetail, @"AirPortName");
        airport.airportEName     = ObjectElementToString(airportDetail, @"AirPortEName");
        airport.airportShortName = ObjectElementToString(airportDetail, @"ShortName");
        airport.cityID           = [ObjectElementToString(airportDetail, @"CityId") integerValue];
        airport.cityName         = ObjectElementToString(airportDetail, @"CityName");
        
        [airportInfo addObject:airport];
    }
    
    domesticAirports = airportInfo;
}

- (void)loadCraftTypes
{
    NSString *craftTypeFile = [[NSBundle mainBundle] pathForResource:@"CraftTypes"
                                                              ofType:@"xml"];
    NSString *craftTypeString = [NSString stringWithContentsOfFile:craftTypeFile
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
    
    GDataXMLDocument *xml = [[GDataXMLDocument alloc] initWithXMLString:craftTypeString
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];
    GDataXMLElement *root = [xml rootElement];
    
    NSArray *craftTypeDetails = [root nodesForXPath:@"//CraftInfoEntity"
                                              error:nil];
    
    NSMutableArray *craftTypeInfo = [NSMutableArray array];
    for (GDataXMLElement *craftTypeDetail in craftTypeDetails) {
        CraftType *craftType = [[CraftType alloc] init];
        
        craftType.craftType  = ObjectElementToString(craftTypeDetail, @"CraftType");
        craftType.ctName     = ObjectElementToString(craftTypeDetail, @"CTName");
        craftType.widthLevel = ObjectElementToString(craftTypeDetail, @"WidthLevel");
        craftType.minSeats   = [ObjectElementToString(craftTypeDetail, @"MinSeats") integerValue];
        craftType.maxSeats   = [ObjectElementToString(craftTypeDetail, @"MaxSeats") integerValue];
        craftType.note       = ObjectElementToString(craftTypeDetail, @"Note");
        craftType.ctEName    = ObjectElementToString(craftTypeDetail, @"Crafttype_ename");
        craftType.craftKind  = ObjectElementToString(craftTypeDetail, @"CraftKind");
        
        [craftTypeInfo addObject:craftType];
    }
    
    craftTypes = craftTypeInfo;
}

- (void)loadAirlines
{
    NSString *airlineFile = [[NSBundle mainBundle] pathForResource:@"Airlines"
                                                            ofType:@"xml"];
    NSString *airlineString = [NSString stringWithContentsOfFile:airlineFile
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    
    GDataXMLDocument *xml = [[GDataXMLDocument alloc] initWithXMLString:airlineString
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];
    GDataXMLElement *root = [xml rootElement];
    
    NSArray *airlineDetails = [root nodesForXPath:@"//AirlineInfoEntity"
                                            error:nil];
    
    NSMutableArray *airlineInfo = [NSMutableArray array];
    for (GDataXMLElement *airlineDetail in airlineDetails) {
        Airline *airline = [[Airline alloc] init];
        
        airline.airline             = ObjectElementToString(airlineDetail, @"AirLine");
        airline.airlineCode         = ObjectElementToString(airlineDetail, @"AirLineCode");
        airline.airlineName         = ObjectElementToString(airlineDetail, @"AirLineName");
        airline.airlineEName        = ObjectElementToString(airlineDetail, @"AirLineEName");
        airline.shortName           = ObjectElementToString(airlineDetail, @"ShortName");
        airline.groupID             = [ObjectElementToString(airlineDetail, @"GroupId") integerValue];
        airline.groupName           = ObjectElementToString(airlineDetail, @"GroupName");
        airline.strictType          = ObjectElementToString(airlineDetail, @"StrictType");
        airline.addonPriceProtected = [ObjectElementToString(airlineDetail, @"AddonPriceProtected") boolValue];
        airline.isSupportAirPlus    = [ObjectElementToString(airlineDetail, @"IsSupportAirPlus") boolValue];
        airline.onlineCheckinUrl    = ObjectElementToString(airlineDetail, @"OnlineCheckinUrl");
        
        [airlineInfo addObject:airline];
    }
    
    airlines = airlineInfo;
}

@end
