//
//  OTAFlightOrderListResponse.h
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAResponse.h"

@interface OTAFlightOrderListResponse : OTAResponse

/**
 *  订单列表
 */
@property (nonatomic, strong) NSArray *orderList;

/**
 *  根据返回的xml初始化OTAFlightOrderListResponse
 *
 *  @param xml 返回的xml
 *
 *  @return 初始化后的对象自身
 */
- (id)initWithOTAFlightOrderListResponse:(NSString *)xml;

@end
