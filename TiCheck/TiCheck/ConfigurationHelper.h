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

// 用于测试
#define TEMPORARY_UNIQUE_UID @"1c02d4dd-b569-411e-b0b6-bbe8a5253b29"
#define TEMPORARY_ORDER_ID @"1F86C2435744433AA557854A5BBC50D9"

typedef NS_ENUM(NSUInteger, FlightRequestType) {
    FlightSearchRequest = 0,
    FlightSaveOrderRequest,
    FlightCancelOrderRequest,
    FlightOrderListRequest,
    FlightViewOrderRequest,
    FlightStatusChangedOrdersRequest,
    UserUniqueID
};

const NSArray *___FlightRequestType;

#define cFlightRequestTypeGet (___FlightRequestType == nil ? ___FlightRequestType = [[NSArray alloc] initWithObjects:\
@"OTA_FlightSearch",\
@"OTA_FltSaveOrder",\
@"OTA_FltCancelOrder",\
@"OTA_FltOrderList",\
@"OTA_FltViewOrder",\
@"OTA_GetStatusChangedOrders",\
@"OTA_UserUniqueID", nil] : ___FlightRequestType)

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
 *  MD5 32位加密算法
 *
 *  @param string 待加密的字串
 *
 *  @return 加密后的字串
 */
- (NSString *)md5:(NSString *)string;


@end
