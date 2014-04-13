//
//  APIResourceHelper.m
//  TiCheck
//
//  Created by Boyi on 4/13/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "APIResourceHelper.h"
#import "GDataXMLNode.h"
#import "DomesticCity.h"

#define ObjectElementToString(object, element) [[[object elementsForName:element] firstObject] stringValue]

@implementation APIResourceHelper {
    NSArray *domesticCities;    // 国内城市信息列表
}

+ (APIResourceHelper *)sharedResourceHelper
{
    static dispatch_once_t pred = 0;
    __strong static APIResourceHelper *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

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
    
    NSArray *cityDetails = [root nodesForXPath:@"//CityDetail" error:nil];
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
        
        city.airports   = airports;
        
        [cityInfo addObject:city];
    }
    
    domesticCities = cityInfo;
}

- (id)init
{
    if (self = [super init]) {
        [self loadDomesticCities];
    }
    
    return self;
}

@end
