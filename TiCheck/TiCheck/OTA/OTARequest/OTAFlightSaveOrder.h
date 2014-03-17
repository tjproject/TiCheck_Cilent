//
//  OTAFlightSaveOrder.h
//  Test
//
//  Created by Boyi on 3/5/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumCollection.h"

@class Contact;
@class DeliverInfo;
@class CreditCardInfo;

@interface OTAFlightSaveOrder : NSObject

/**
 *  订单类型：string类型；必填；ADU（成人），CHI（儿童）， BAB（婴儿）
 */
@property (nonatomic) AgeType ageType;

/**
 *  订单金额：必填
 */
@property (nonatomic) CGFloat amount;

/**
 *  订单处理描述：string类型；必填
 */
@property (nonatomic, strong) NSString *processDescription;

/**
 *  航班列表
 */
@property (nonatomic, strong) NSArray *flightInfoList;

/**
 *  乘机人列表
 */
@property (nonatomic, strong) NSArray *passengerList;

/**
 *  订单联系人
 */
@property (nonatomic, strong) Contact *contact;

/**
 *  配送信息
 */
@property (nonatomic, strong) DeliverInfo *deliverInfo;

/**
 *  对方收款添加信用卡信息（需要联系业务开通，输入信用卡信息会返回正式的订单好，默认的情况是不
 *  开通，此节点可以为空，只返回临时订单号，然后根据临时订单号需要调用携程的支付页面，让用户通过支付页面付款）
 */
@property (nonatomic, strong) CreditCardInfo *creditCardInfo;

/**
 *  根据订单信息生成对应xml请求body
 *
 *  @return 订单生成请求xml的Body
 */
- (NSString *)generateOTAFlightSaveOrderXMLRequest;

@end
