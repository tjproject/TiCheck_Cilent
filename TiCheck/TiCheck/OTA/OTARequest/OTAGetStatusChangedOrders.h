//
//  OTAGetStatusChangedOrders.h
//  Test
//
//  Created by Boyi on 3/11/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAGetStatusChangedOrders : NSObject

/**
 *  检查变更时间：DateTime类型；必填；返回这个时间之后的状态发生变更的订单集合，日期必须在当前日期30天前以内
 */
@property (nonatomic, strong) NSDate *changedTime;

@end
