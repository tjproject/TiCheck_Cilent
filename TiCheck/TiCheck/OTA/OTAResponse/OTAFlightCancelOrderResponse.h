//
//  OTAFlightCancelOrderResponse.h
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAResponse.h"

@interface OTAFlightCancelOrderResponse : OTAResponse

/**
 *  取消结果：true成功，false失败
 */
@property (nonatomic) BOOL result;

/**
 *  提示信息
 */
@property (nonatomic, strong) NSString *message;

/**
 *  根据返回的xml初始化OTAFlightCancelOrderResponse
 *
 *  @param xml 返回的xml
 *
 *  @return 初始化后的对象自身
 */
- (id)initWithOTAFlightCancelOrderResponse:(NSString *)xml;

@end
