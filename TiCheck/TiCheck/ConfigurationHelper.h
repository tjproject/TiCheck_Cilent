//
//  ConfigurationHelper.h
//  Test
//
//  Created by Boyi on 3/3/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALLIANCE_ID 4341
#define STATION_ID 439437
#define STATION_KEY @"ED2C1865-E81C-424E-A05C-5DEE7DFF92EB"

#define API_URL @"http://openapi.ctrip.com/"
#define XML_NAME_SPACE @"http://ctrip.com/"
#define WEB_SERVICE_NAME @"Request"
#define SERVER_URL @"http://www.ticheck.com/server/index.php"
//#define SERVER_URL @"http://127.0.0.1/TiCheck_Server/index.php"
//#define SERVER_URL @"http://10.60.41.52/server/index.php"
#define BUSINESS_TYPE @"Flight"

// 用于测试
#define TEMPORARY_UNIQUE_UID @"a19265a5-21c1-40a1-841d-e9605bfe53a7"

typedef NS_ENUM(NSUInteger, FlightRequestType) {
    FlightSearchRequest = 0,
    FlightSaveOrderRequest,
    FlightCancelOrderRequest,
    FlightOrderListRequest,
    FlightViewOrderRequest,
    FlightStatusChangedOrdersRequest,
    UserUniqueID,
    PaymentEntry
};

const NSArray *___FlightRequestType;

#define cFlightRequestTypeGet (___FlightRequestType == nil ? ___FlightRequestType = [[NSArray alloc] initWithObjects:\
@"OTA_FlightSearch",\
@"OTA_FltSaveOrder",\
@"OTA_FltCancelOrder",\
@"OTA_FltOrderList",\
@"OTA_FltViewOrder",\
@"OTA_GetStatusChangedOrders",\
@"OTA_UserUniqueID",\
@"mobilepayentry", nil] : ___FlightRequestType)

#define cFlightRequestTypeString(type) ([cFlightRequestTypeGet objectAtIndex:type])
#define cFlightRequestTypeEnum(string) ([cFlightRequestTypeGet indexOfObject:string])

@interface ConfigurationHelper : NSObject

/**
 *  当前登录的用户携程UID，未登录则为nil
 */
@property (nonatomic, strong) NSString *currentUserID;

/**
 *  ConfigurationHelper单例创建
 *
 *  @return ConfigurationHelper单例的实例
 */
+ (id)sharedConfigurationHelper;

/**
*  获取界面输入的联盟信息对应的字符串
*
*  @param requestType 请求的类型
*
*  @return 生成Header
*/
- (NSString *)getHeaderStringWithRequestType:(FlightRequestType)requestType;

/**
 *  获取界面输入的联盟信息对应的字符串URL
 *
 *  @param requestType 请求的类型
 *
 *  @return 生成Header
 */
- (NSString *)getURLStringWithRequestType:(FlightRequestType)requestType;
/**
 *  MD5 32位加密算法
 *
 *  @param string 待加密的字串
 *
 *  @return 加密后的字串
 */
- (NSString *)md5:(NSString *)string;

/**
 *  MD5 32位加密算法，结果转换为大写
 *
 *  @param string 待加密的字串
 *
 *  @return 加密后并转换为大写的字串
 */
- (NSString *)MD5ExtWithUpperCase:(NSString *)string;

/**
 *  重置数据，设置
 */
- (void)resetAll;

@end
