//
//  FlightOrder.h
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAResponse.h"
#import "EnumCollection.h"
#import "OTAFlightSaveOrder.h"
#define ORDER_ID @"OrderID"
#define ORDER_TIME @"OrderTime"
#define AMOUNT @"Amount"
#define ORDER_DESC @"OrderDesc"
#define PERSONS @"Persons"

@class DeliverInfo;

@interface Order : NSObject

/**
 *  航班信息列表（必填）
 */
@property (nonatomic, strong) NSArray *flightsList;

/**
 *  乘客信息列表（必填）
 */
@property (nonatomic, strong) NSArray *passengersList;

/**
 *  订单号（必填）
 */
@property (nonatomic, strong) NSString *OrderID;

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
 *  订单状态：W-未处理，P-处理中，S-已成交，C-已取消，R-全部退票，T-部分退票，U-未提交 （必填）
 */
@property (nonatomic) OrderStatus orderStatus;

/**
 *  订单总金额（必填）- ?（不确定）包括保险费 ？
 */
@property (nonatomic) NSInteger amount;

/**
 *  保险费（必填）
 */
@property (nonatomic) NSInteger insuranceFee;

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
 *  是否英文
 */
@property (nonatomic) BOOL isEnglish;

/**
 *  订单分类：D国内机票，I国际机票
 */
@property (nonatomic) FlightOrderClass flightOrderClass;

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

/**
 *  创建并返回一个 order 订单实例
 *  @param orderId          机票订单号（目前为临时订单号）
 *  @param flighs           航班列表
 *  @param passengers       乘机人列表
 *  @param status           订单状态
 *  @param tAmount          总价格
 *  @param fee              保险价格
 *  @return 订单实例
 */
+ (Order *)orderWithOrderId:(NSString *)orderId
                flightsList:(NSArray *)flighs
             passengersList:(NSArray *)passengers
                orderStatus:(OrderStatus)status
                totalAmount:(NSInteger)tAmount
                  insurance:(NSInteger)fee;

/**
 *  由字典创建返回一个 order 实例
 *
 *  @param dictionary 字典
 *
 *  @return 订单实例数组集合
 */
+ (NSMutableArray *)orderWithDiscitionary:(NSDictionary*) dictionary;


+ (Order *)createOrderWithDictionary:(NSDictionary *)dictionary;

@end
