//
//  OTAFlightSaveOrderResponse.h
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAResponse.h"

@interface OTAFlightSaveOrderResponse : OTAResponse

/**
 *  提交结果
 */
@property (nonatomic) BOOL result;

/**
 *  提交结果提示
 */
@property (nonatomic, strong) NSString *resultMsg;

/**
 *  临时订单号，若为通过支付API付款则返回临时订单号，等待跳转支付API完成支付后自动提交
 */
@property (nonatomic, strong) NSString *tempOrderID;

/**
 *  正式订单号，若为自行收取信用卡，则返回正式订单号
 */
@property (nonatomic, strong) NSString *orderID;

/**
 *  根据返回的xml初始化OTAFlightSaveOrderResponse
 *
 *  @param xml 返回的xml
 *
 *  @return 初始化后的对象自身
 */
- (id)initWithOTASaveOrderResponse:(NSString *)xml;

@end
