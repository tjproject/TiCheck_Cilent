//
//  APIResourceHelper.h
//  TiCheck
//
//  Created by Boyi on 4/13/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DomesticCity;
@class Airport;
@class CraftType;
@class Airline;

@interface APIResourceHelper : NSObject

/**
 *  单例
 *
 *  @return 单例
 */
+ (APIResourceHelper *)sharedResourceHelper;

#pragma mark - 国内城市搜索

/**
 *  通过城市ID搜索国内城市
 *
 *  @param cityID 城市ID
 *
 *  @return 国内城市
 */
- (DomesticCity *)findDomesticCityViaID:(NSInteger)cityID;

/**
 *  通过城市三字码搜索国内城市
 *
 *  @param cityCode 城市三字码
 *
 *  @return 国内城市
 */
- (DomesticCity *)findDomesticCityViaCode:(NSString *)cityCode;

/**
 *  通过城市名搜索国内城市
 *
 *  @param cityName 城市名
 *
 *  @return 国内城市
 */
- (DomesticCity *)findDomesticCityViaName:(NSString *)cityName;

/**
 *  获得所有城市中文名
 *
 *  @return 城市中文名列表
 */
- (NSArray *)findAllCityNameContainsAirport;

#pragma mark - 机场搜索

/**
 *  通过机场三字码搜索机场
 *
 *  @param airportCode 机场三字码
 *
 *  @return 机场
 */
- (Airport *)findAirportViaCode:(NSString *)airportCode;

/**
 *  通过机场名搜索机场
 *
 *  @param airportName 机场名
 *
 *  @return 机场
 */
- (Airport *)findAirportViaName:(NSString *)airportName;

/**
 *  通过城市ID搜索所有机场
 *
 *  @param cityID 城市ID
 *
 *  @return 城市中所有机场
 */
- (NSArray *)findAirportViaCityID:(NSInteger)cityID;

/**
 *  通过城市名搜索机场名称
 *
 *  @param cityName 城市名
 *
 *  @return 城市所有机场名
 */
- (NSArray *)findAirportsNameInCity:(NSString *)cityName;

#pragma mark - 机型搜索

/**
 *  通过机型号搜索机型
 *
 *  @param craftType 机型号
 *
 *  @return 机型
 */
- (CraftType *)findCraftTypeViaCT:(NSString *)craftType;

#pragma mark - 航空公司搜索

/**
 *  获得所有航空公司名
 *
 *  @return 航空公司名数组
 */
- (NSArray *)findAllAirlineShortNames;

/**
 *  通过航空公司二字码搜索航空公司
 *
 *  @param airlineCode 航空公司二字码
 *
 *  @return 航空公司
 */
- (Airline *)findAirlineViaAirlineDibitCode:(NSString *)airlineDibitCode;

/**
 *  根据航空公司简称搜索航空公司
 *
 *  @param airlineShortName 要搜索的航空公司简称
 *
 *  @return 航空公司
 */
- (Airline *)findAirlineViaAirlineShortName:(NSString *)airlineShortName;

/**
 *  根据航空公司名搜索航空公司
 *
 *  @param airlineName 要搜索的航空公司名称
 *
 *  @return 航空公司
 */
- (Airline *)findAirlineViaAirlineName:(NSString *)airlineName;

@end
