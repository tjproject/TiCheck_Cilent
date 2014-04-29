//
//  ServerCommunicator.h
//  TiCheck
//
//  Created by Boyi on 4/28/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_DEPART_CITY_KEY @"DepartCity"
#define SERVER_ARRIVE_CITY_KEY @"ArriveCity"
#define SERVER_START_DATE_KEY @"StartDate"
#define SERVER_END_DATE_KEY @"EndDate"
#define SERVER_EARLIEST_DEPART_TIME_KEY @"EarliestDepartTime"
#define SERVER_LASTEST_DEPART_TIME_KEY @"LatestDepartTime"
#define SERVER_AIRLINE_DIBIT_CODE_KEY @"AirlineDibitCode"
#define SERVER_ARRIVE_AIRPORT @"ArriveAirport"
#define SERVER_DEPART_AIRPORT @"DepartAirport"

@interface ServerCommunicator : NSObject

/**
 *  单例
 *
 *  @return 单例
 */
+ (ServerCommunicator *)sharedCommunicator;

/**
 *  创建用户
 *
 *  @param email    用户邮箱
 *  @param password 用户密码
 *  @param account  用户账户名
 *
 *  @return 是否成功创建
 */
- (BOOL)createUserWithEmail:(NSString *)email password:(NSString *)password account:(NSString *)account;

/**
 *  修改用户，如果只修改某几项，其他项用UserData获取填原来的数值
 *
 *  @param newEmail    用户新邮箱
 *  @param newPassword 用户新密码
 *  @param newAccount  用户新账户名
 *
 *  @return 是否成功修改
 */
- (BOOL)modifyUserWithEmail:(NSString *)newEmail password:(NSString *)newPassword account:(NSString *)newAccount;

/**
 *  验证登录
 *
 *  @param email 用户邮箱
 *  @param password 用户密码
 *
 *  @return 是否验证成功
 */
- (BOOL)loginVerifyWithEmail:(NSString *)email password:(NSString *)password;

/**
 *  创建一个订阅
 *
 *  @param departCityName 出发城市名
 *  @param arriveCityName 返回城市名
 *  @param startDate      开始日期
 *  @param endDate        结束日期
 *  @param moreOptionDic  更多选项的字典，其中的Key在本文件开始起始处定义，不要求全填
 *
 *  @return 是否创建成功
 */
- (BOOL)createSubscriptionWithDepartCity:(NSString *)departCityName
                              arriveCity:(NSString *)arriveCityName
                               startDate:(NSDate *)startDate
                                 endDate:(NSDate *)endDate
                              moreOption:(NSDictionary *)moreOptionDic;

@end
