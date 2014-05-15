//
//  Subscription.h
//  TiCheck
//
//  Created by Boyi on 4/29/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_DEPART_CITY_KEY @"DepartCity"
#define SERVER_ARRIVE_CITY_KEY @"ArriveCity"
#define SERVER_START_DATE_KEY @"StartDate"
#define SERVER_END_DATE_KEY @"EndDate"
#define SERVER_EARLIEST_DEPART_TIME_KEY @"EarliestDepartTime"
#define SERVER_LATEST_DEPART_TIME_KEY @"LatestDepartTime"
#define SERVER_AIRLINE_DIBIT_CODE_KEY @"AirlineDibitCode"
#define SERVER_ARRIVE_AIRPORT_KEY @"ArriveAirport"
#define SERVER_DEPART_AIRPORT_KEY @"DepartAirport"

@class DomesticCity;
@class Airline;
@class Airport;

@interface Subscription : NSObject

/**
 *  出发城市，必填
 */
@property (nonatomic, strong, readonly) DomesticCity *departCity;

/**
 *  到达城市，必填
 */
@property (nonatomic, strong, readonly) DomesticCity *arriveCity;

/**
 *  开始时间，必填
 */
@property (nonatomic, strong, readonly) NSDate *startDate;

/**
 *  结束时间，必填
 */
@property (nonatomic, strong, readonly) NSDate *endDate;

/**
 *  出发时间段，选填，如08:00:00
 */
@property (nonatomic, strong, readonly) NSString *earliestDepartTime;

/**
 *  到达时间段，选填，如12:00:00
 */
@property (nonatomic, strong, readonly) NSString *latestDepartTime;

/**
 *  航空公司，选填
 */
@property (nonatomic, strong, readonly) Airline *airline;

/**
 *  到达机场，选填
 */
@property (nonatomic, strong, readonly) Airport *arriveAirport;

/**
 *  出发机场，选填
 */
@property (nonatomic, strong, readonly) Airport *departAirport;

/**
 *  采用必填信息初始化，选填信息全部设置为空
 *
 *  @param departCityName 出发城市名
 *  @param arriveCityName 到达城市名
 *  @param startDate      订阅的开始时间字符串
 *  @param endDate        订阅的结束时间字符串
 *
 *  @return 初始化的订阅类
 */
- (id)initWithDepartCity:(NSString *)departCityName
              arriveCity:(NSString *)arriveCityName
               startDate:(NSString *)startDateStr
                 endDate:(NSString *)endDateStr;

/**
 *  采用必填信息初始化，选填信息全部设置为空
 *
 *  @param departCityCode 出发城市名编号
 *  @param arriveCityCode 到达城市名编号
 *  @param startDate      订阅的开始时间字符串
 *  @param endDate        订阅的结束时间字符串
 *
 *  @return 初始化的订阅类
 */
- (id)initWithDepartCityCode:(NSString *)departCityCode
              arriveCityCode:(NSString *)arriveCityCode
                   startDate:(NSString *)startDateStr
                     endDate:(NSString *)endDateStr;



/**
 *  添加更多选项，如果不限则传空字符串
 *
 *  @param earliestDepartTime 出发最早时间，如08:00:00
 *  @param latestDepartTime   出发最晚时间，如12:00:00
 *  @param airlineDibitCode   航空公司二字码
 *  @param arriveAirportCode  到达机场三字码
 *  @param departAirportCode  出发机场三字码
 */
- (void)modifyMoreOptionWithEarliestDepartTime:(NSString *)earliestDepartTime
                              LatestDepartTime:(NSString *)latestDepartTime
                              airlineShortName:(NSString *)airlineShortName
                             arriveAirportName:(NSString *)arriveAirportName
                             departAirportName:(NSString *)departAirportName;

/**
 *  生成订阅信息的字典，用于转换为json格式数据
 *
 *  @return 订阅信息的Dictionary
 */
- (NSDictionary *)dictionaryWithSubscriptionOption;

@end
