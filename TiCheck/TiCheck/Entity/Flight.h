//
//  Flight.h
//  Test
//
//  Created by Boyi on 3/5/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumCollection.h"

@interface Flight : NSObject

/**
 *  出发城市ID
 */
@property (nonatomic) NSInteger departCityID;

/**
 *  到达城市ID
 */
@property (nonatomic) NSInteger arriveCityID;

/**
 *  出发机场三字码
 */
@property (nonatomic, strong) NSString *departCityCode;

/**
 *  到达机场三字码
 */
@property (nonatomic, strong) NSString *arriveCityCode;

/**
 *  出发城市名称
 */
@property (nonatomic, strong) NSString *departCityName;

/**
 *  到达城市名称
 */
@property (nonatomic, strong) NSString *arriveCityName;

/**
 *  起飞时间
 */
@property (nonatomic, strong) NSDate *takeOffTime;

/**
 *  抵达时间
 */
@property (nonatomic, strong) NSDate *arrivalTime;

/**
 *  航班号
 */
@property (nonatomic, strong) NSString *flightNumber;

/**
 *  机型
 */
@property (nonatomic, strong) NSString *craftType;

/**
 *  航空公司代码
 */
@property (nonatomic, strong) NSString *airlineCode;

/**
 *  航空公司中文名称
 */
@property (nonatomic, strong) NSString *airlineName;

/**
 *  舱位等级：对应航班查询结果的FlightClass 字段
 */
@property (nonatomic) ClassGrade classGrade;

/**
 *  舱位名称
 */
@property (nonatomic, strong) NSString *classGradeName;

/**
 *  子舱位
 */
@property (nonatomic, strong) NSString *subClass;

/**
 *  显示用舱位
 */
@property (nonatomic, strong) NSString *displaySubClass;

/**
 *  乘客年龄类型：ADU（成人）/CHI（儿童）/ BAB（婴儿）
 */
@property (nonatomic) AgeType ageType;

/**
 *  航班扣率
 */
@property (nonatomic) CGFloat rate;

/**
 *  航班票价
 */
@property (nonatomic) NSInteger price;

/**
 *  标准价
 */
@property (nonatomic) NSInteger standardPrice;

/**
 *  儿童标准价
 */
@property (nonatomic) NSInteger childStandardPrice;

/**
 *  婴儿标准价
 */
@property (nonatomic) NSInteger babyStandardPrice;

/**
 *  餐食类型
 */
@property (nonatomic, strong) NSString *mealType;

/**
 *  成人税
 */
@property (nonatomic) NSInteger adultTax;

/**
 *  婴儿税
 */
@property (nonatomic) NSInteger babyTax;

/**
 *  儿童税
 */
@property (nonatomic) NSInteger childTax;

/**
 *  成人燃油费用
 */
@property (nonatomic) CGFloat adultOilFee;

/**
 *  婴儿燃油费用
 */
@property (nonatomic) CGFloat babyOilFee;

/**
 *  儿童燃油费用
 */
@property (nonatomic) CGFloat childOilFee;

/**
 *  金额
 */
@property (nonatomic) CGFloat amount;

/**
 *  出发机场名称
 */
@property (nonatomic, strong) NSString *departPortName;

/**
 *  到达机场名称
 */
@property (nonatomic, strong) NSString *arrivePortName;

/**
 *  出发机场简称
 */
@property (nonatomic, strong) NSString *departPortShortName;

/**
 *  到达机场简称
 */
@property (nonatomic, strong) NSString *arrivePortShortName;

/**
 *  出发机场代码
 */
@property (nonatomic, strong) NSString *departPortCode;

/**
 *  抵达机场代码
 */
@property (nonatomic, strong) NSString *arrivePortCode;

/**
 *  出发机场航站楼ID
 */
@property (nonatomic) NSInteger departPortBuildingID;

/**
 *  到达机场航站楼ID
 */
@property (nonatomic) NSInteger arrivePortBuildingID;

/**
 *  出发机场航站楼名称
 */
@property (nonatomic, strong) NSString *departPortBuildingName;

/**
 *  到达机场航站楼名称
 */
@property (nonatomic, strong) NSString *arrivePortBuildingName;

/**
 *  出发机场航站楼简称
 */
@property (nonatomic, strong) NSString *departPortBuildingShortName;

/**
 *  到达机场航站楼简称
 */
@property (nonatomic, strong) NSString *arrivePortBuildingShortName;

/**
 *  到达航站楼地址
 */
@property (nonatomic, strong) NSString *arrivePortAddress;

/**
 *  到达航站楼短信名称
 */
@property (nonatomic, strong) NSString *arrivePortSMSName;

/**
 *  经停次数
 */
@property (nonatomic) NSInteger stopTimes;

/**
 *  更改标示
 */
@property (nonatomic, strong) NSString *nonRer;

/**
 *  转签标示
 */
@property (nonatomic, strong) NSString *nonEnd;

/**
 *  退票标示
 */
@property (nonatomic, strong) NSString *nonRef;

/**
 *  更改说明 （中文 或 英文）中文、英文 的显示取决于请求Header 节Culture 值
 */
@property (nonatomic, strong) NSString *rerNote;

/**
 *  转签说明 （中文 或 英文）中文、英文 的显示取决于请求Header 节Culture 值
 */
@property (nonatomic, strong) NSString *endNote;

/**
 *  转签说明 （中文 或 英文）中文、英文 的显示取决于请求Header 节Culture 值
 */
@property (nonatomic, strong) NSString *refNote;

/**
 *  备注 （中文或英文）中文、英文 的显示取决于请求Header 节Culture 值
 */
@property (nonatomic, strong) NSString *remarks;

/**
 *  票种,中文、英文 的显示取决于请求Header 节Culture 值
 */
@property (nonatomic, strong) NSString *ticketType;

/**
 *  提前预定天数
 */
@property (nonatomic) NSInteger beforeFlyDate;

/**
 *  剩余票量Int32 中文、英文 的显示取决于请求Header 节Culture 值
 */
@property (nonatomic) NSInteger quantity;

/**
 *  价格类型 NormalPrice ：普通,SingleTripPrice：提前预售特价,CZSpecialPrice：南航特价
 */
@property (nonatomic) PriceType priceType;

/**
 *  机票产品类型:Normal,YOUNGMAN,OLDMAN
 */
@property (nonatomic) ProductType productType;

/**
 *  机票产品来源:1携程机票频道,2共享平台,3两者共有,4直连产品
 */
@property (nonatomic) ProductSource productSource;

/**
 *  库存类型:FIX：定额   FAV：见舱
 */
@property (nonatomic) InventoryType inventoryType;

/**
 *  航程索引
 */
@property (nonatomic) NSInteger routeIndex;

/**
 *  是否K位
 */
@property (nonatomic) BOOL needApplyString;

/**
 *  推荐等级
 */
@property (nonatomic) NSInteger recommend;

/**
 *  退票费计算公式ID
 */
@property (nonatomic) NSInteger refundFeeFormulaID;

/**
 *  是否可升舱
 */
@property (nonatomic) BOOL canUpGrade;

/**
 *  是否可以单独销售
 */
@property (nonatomic, strong) NSString* canSeparateSale;

/**
 *  是否随订随售
 */
@property (nonatomic) BOOL canNoDefer;

/**
 *  是否飞人航班
 */
@property (nonatomic) BOOL isFlyMan;

/**
 *  是否政策限本地
 */
@property (nonatomic) BOOL onlyOwnCity;

/**
 *  是否最低价
 */
@property (nonatomic) BOOL isLowestPrice;

/**
 *  是否南航最低价
 */
@property (nonatomic) BOOL isLowestCZSpecialPrice;

/**
 *  参考准点率
 */
@property (nonatomic) CGFloat punctualityRate;

/**
 *  政策ID
 */
@property (nonatomic, strong) NSString *policyID;

/**
 *  原政策可出票种:对应航班查询结果中的DeliverTicketType 字段
 */
@property (nonatomic, strong) NSString *allowCPType;

/**
 *  是否超出邮寄时间
 */
@property (nonatomic) BOOL outOfPostTime;

/**
 *  是否在送票取票时间之外
 */
@property (nonatomic) BOOL outOfSendGetTime;

/**
 *  是否在柜台取票时间之外
 */
@property (nonatomic) BOOL outOfAirlineCounterTime;

/**
 *  是否可邮寄
 */
@property (nonatomic) BOOL canPost;

/**
 *  是否可航空公司柜台取消
 */
@property (nonatomic) BOOL canAirlineCounter;

/**
 *  是否可市内送票取票
 */
@property (nonatomic) BOOL canSendGet;

/**
 *  是否返现
 */
@property (nonatomic) BOOL isRebate;

/**
 *  返现金额
 */
@property (nonatomic) CGFloat rebateAmount;

@property (nonatomic) NSString *rebateCPCity;

/**
 *  是否有机场航站楼信息
 */
@property (nonatomic) BOOL hasAirportBuildingInformation;

/**
 *  是否有地面程
 */
@property (nonatomic) BOOL isSurface;

/**
 *  登机时间
 */
@property (nonatomic, strong) NSDate *checkInTime;

/**
 *  服务费
 */
@property (nonatomic) CGFloat serverFee;

@end
