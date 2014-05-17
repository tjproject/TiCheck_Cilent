//
//  FlightOrder.h
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAResponse.h"
#import "EnumCollection.h"

#define ORDER_ID @"OrderID"
#define ORDER_TIME @"OrderTime"
#define AMOUNT @"Amount"
#define ORDER_DESC @"OrderDesc"
#define PERSONS @"Persons"

@class DeliverInfo;

@interface Order : NSObject

/**
 *  送票城市
 */
@property (nonatomic, strong) NSString *sendTicketCity;

/**
 *  送票城市ID，参见静态文件-国内城市
 */
@property (nonatomic) NSInteger sendTicketCityID;

/**
 *  航班类型：S 单程 M联程 D往返
 */
@property (nonatomic) FlightSearchType flightWay;

/**
 *  订单号
 */
@property (nonatomic, strong) NSString *OrderID;

/**
 *  订单时间
 */
@property (nonatomic, strong) NSDate *orderTime;

/**
 *  最后修改时间
 */
@property (nonatomic, strong) NSDate *latestChangedTime;

/**
 *  订单描述
 */
@property (nonatomic, strong) NSString *orderDesc;

/**
 *  订单状态：W-未处理，P-处理中，S-已成交，C-已取消，R-全部退票，T-部分退票，U-未提交
 */
@property (nonatomic) OrderStatus orderStatus;

/**
 *  订单总金额
 */
@property (nonatomic) NSInteger amount;

/**
 *  电子券/游票支付金额
 */
@property (nonatomic) NSInteger emoney;

/**
 *  实际金额
 */
@property (nonatomic) NSInteger actualAmount;

/**
 *  信用卡支付费
 */
@property (nonatomic) CGFloat cCardPayFee;

/**
 *  服务费
 */
@property (nonatomic) CGFloat serverFee;

/**
 *  订单处理状态
 */
@property (nonatomic) NSInteger processStatus;

/**
 *  送票费
 */
@property (nonatomic) NSInteger sendTicketFee;

/**
 *  取票方式
 */
@property (nonatomic, strong) NSString *getTicketWay;

/**
 *  电子账户
 */
@property (nonatomic) NSInteger eAccountAmount;

/**
 *  人数
 */
@property (nonatomic) NSInteger persons;

/**
 *  保险费
 */
@property (nonatomic) NSInteger insuranceFee;

/**
 *  是否英文
 */
@property (nonatomic) BOOL isEnglish;

/**
 *  订单分类：D国内机票，I国际机票
 */
@property (nonatomic) FlightOrderClass flightOrderClass;

/**
 *  航班信息列表
 */
@property (nonatomic, strong) NSArray *flightsList;

/**
 *  乘客信息列表
 */
@property (nonatomic, strong) NSArray *passengersList;

/**
 *  配送信息
 */
@property (nonatomic, strong) DeliverInfo *deliver;

/**
 *  经停信息
 */
@property (nonatomic, strong) NSString *stopsInfo;

/**
 *  提示信息
 */
@property (nonatomic, strong) NSString *promopts;

/**
 *  生成订单信息的字典，用于转换为json格式数据
 *
 *  @return 订单信息的Dictionary
 */
- (NSDictionary *)dictionaryWithOrderOption;

@end
