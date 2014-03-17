//
//  CreditCardInfo.h
//  Test
//
//  Created by Boyi on 3/12/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  对方收款添加信用卡信息（需要联系业务开通，输入信用卡信息会返回正式的订单好，默认的情况是不开通，此节点可以为空，只返回临时订单号，然后根据临时订单号需要调用携程的支付页面，让用户通过支付页面付款）
 */
@interface CreditCardInfo : NSObject

/**
 *  信用卡信息编号：Int类型；可空；此字段为0,每次支付新增信用卡信息到数据库，同时接口返回CardInfoID
 */
@property (nonatomic, strong) NSString *cardInfoID;

/**
 *  信用卡卡种：Int类型；必填，请参考静态文件codelist中的CCT
 */
@property (nonatomic, strong) NSString *creditCardType;

/**
 *  信用卡卡号：String类型；必填，使用信用卡加密
 */
@property (nonatomic, strong) NSString *creditCardNumber;

/**
 *  有效日期：String类型；必填，yyyyMM（年4位+月2位）使用信用卡加密
 */
@property (nonatomic, strong) NSString *validity;

/**
 *  卡号前六位数：String类型；必填，使用信用卡加密
 */
@property (nonatomic, strong) NSString *cardBin;

/**
 *  持卡人：String类型；必填，使用信用卡加密
 */
@property (nonatomic, strong) NSString *cardHolder;

/**
 *  持卡人证件类型：Int类型；必填，须默认0使用信用卡加密
 */
@property (nonatomic, strong) NSString *idCardType;

/**
 *  持卡人证件号：String类型；必填，使用信用卡加密
 */
@property (nonatomic, strong) NSString *idNumber;

/**
 *  检查码：String类型；必填，使用信用卡加密
 */
@property (nonatomic, strong) NSString *cvv2No;

/**
 *  支付通协议号/手机支付手机号：String类型；必填
 */
@property (nonatomic, strong) NSString *agreementCode;

@property (nonatomic, strong) NSString *eid;

/**
 *  备注：String类型；可空
 */
@property (nonatomic, strong) NSString *remark;

/**
 *  持卡人是否登机人：Bool类型；可空
 */
@property (nonatomic) BOOL isClient;

/**
 *  外卡支付手续费：Decimal类型；可空，须默认0
 */
@property (nonatomic) CGFloat cCardPayFee;

/**
 *  外卡支付手续费率：Decimal类型；可空，须默认0
 */
@property (nonatomic) CGFloat cCardPayFeeRate;

/**
 *  外币额的偏移量：Int类型；可空
 */
@property (nonatomic) NSInteger exponent;

/**
 *  DCC外币汇率原始串：String类型；可空
 */
@property (nonatomic, strong) NSString *exchangeRate;

/**
 *  DCC 外币金额原始串：String类型；可空
 */
@property (nonatomic, strong) NSString *fAmount;

@end
