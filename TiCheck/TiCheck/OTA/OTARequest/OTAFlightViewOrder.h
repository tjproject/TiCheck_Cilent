//
//  OTAFlightViewOrder.h
//  Test
//
//  Created by Boyi on 3/11/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAFlightViewOrder : NSObject

/**
 *  用户UID
 */
@property (nonatomic, strong) NSString *uniqueUID;

/**
 *  订单号列表：Int类型；必填
 */
@property (nonatomic, strong) NSArray *orderIDs;

/**
 *  初始化ViewOrder请求
 *
 *  @param uniqueID 用户UID
 *  @param orders   要请求的Order列表
 *
 *  @return 初始化后的ViewOrder
 */
- (id)initWithUserUniqueUID:(NSString *)uniqueID
                 orderLists:(NSArray *)orders;

/**
 *  根据订单号信息生成对应订单详情xml的请求body
 *
 *  @return 订单详情xml的请求body
 */
- (NSString *)generateOTAFlightViewOrderXMLRequest;

@end
