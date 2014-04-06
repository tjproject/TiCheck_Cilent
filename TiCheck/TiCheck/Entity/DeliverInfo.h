//
//  DeliverInfo.h
//  Test
//
//  Created by Boyi on 3/12/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumCollection.h"

@interface DeliverInfo : NSObject

/**
 *  配送方式：PJS 邮寄行程单,PJN 不需要
 */
@property (nonatomic) DeliveryType deliveryType;

/**
 *  配送方式
 */
@property (nonatomic, strong) NSString *deliveryTypeName;

/**
 *  配送时间
 */
@property (nonatomic, strong) NSString *deliverTimeStr;

/**
 *  送票城市ID
 */
@property (nonatomic, strong) NSString *sendTicketCityID;

/**
 *  订单备注
 */
@property (nonatomic, strong) NSString *orderRemark;

/**
 *  收件人
 */
@property (nonatomic, strong) NSString *receiverName;

/**
 *  省
 */
@property (nonatomic, strong) NSString *province;

/**
 *  市
 */
@property (nonatomic, strong) NSString *city;

/**
 *  区
 */
@property (nonatomic, strong) NSString *canton;

/**
 *  详细地址
 */
@property (nonatomic, strong) NSString *address;

/**
 *  邮编
 */
@property (nonatomic, strong) NSString *postCode;

/**
 *  配送费
 */
@property (nonatomic, strong) NSString *deliverFeeStr;

/**
 *  支付方式
 */
@property (nonatomic, strong) NSString *prePayType;

/**
 *  支付方式名称
 */
@property (nonatomic, strong) NSString *prepayTypeName;

/**
 *  联系人姓名
 */
@property (nonatomic, strong) NSString *contactName;

/**
 *  联系人电话号码
 */
@property (nonatomic, strong) NSString *contactPhone;

/**
 *  联系人手机号码
 */
@property (nonatomic, strong) NSString *contactMobile;

/**
 *  联系人Email
 */
@property (nonatomic, strong) NSString *contactEmail;

/**
 *  最早送票时间
 */
@property (nonatomic, strong) NSDate *sendTicketETime;

/**
 *  最晚送票时间
 */
@property (nonatomic, strong) NSDate *sendTicketLTime;

/**
 *  配送方式
 */
@property (nonatomic, strong) NSString *getTicketWay;

/**
 *  创建并初始化不需要送票的DeliverInfo实例
 *
 *  @return 不需要送票的DeliverInfo实例
 */
+ (DeliverInfo *)deliverInfoWithoutTicketSend;

@end
