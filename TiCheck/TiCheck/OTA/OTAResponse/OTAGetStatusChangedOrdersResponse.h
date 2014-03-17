//
//  OTAGetStatusChangedOrdersResponse.h
//  Test
//
//  Created by Boyi on 3/17/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAResponse.h"

@interface OTAGetStatusChangedOrdersResponse : OTAResponse

/**
 *  订单数量
 */
@property (nonatomic) NSInteger recordCount;

/**
 *  订单变更列表
 */
@property (nonatomic, strong) NSArray *changedOrders;

/**
 *  根据返回的xml初始化OTAGetStatusChangedOrdersResponse
 *
 *  @param xml 返回的xml
 *
 *  @return 初始化后的对象自身
 */
- (id)initWithOTAGetStatusChangedOrdersResponse:(NSString *)xml;

@end
