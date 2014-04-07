//
//  OTAFlightViewOrderResponse.h
//  Test
//
//  Created by Boyi on 3/17/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAResponse.h"

@interface OTAFlightViewOrderResponse : OTAResponse

/**
 *  结果
 */
@property (nonatomic) BOOL result;

/**
 *  提示信息
 */
@property (nonatomic, strong) NSString *resultMessage;

/**
 *  订单信息详情列表
 */
@property (nonatomic, strong) NSArray *ordersInfoList;

/**
 *  查询失败的订单列表
 */
@property (nonatomic, strong) NSArray *failedOrderList;

/**
 *  根据返回的xml初始化OTAFlightViewOrderResponse
 *
 *  @param xml 返回的xml
 *
 *  @return 初始化后的对象自身
 */
- (id)initWithOTAFlightViewOrderResponse:(NSString *)xml;

/**
 *  判断是否有订单结果
 *
 *  @return 是否有订单结果
 */
- (BOOL)hasOrderRecord;

@end
