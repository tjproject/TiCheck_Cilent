//
//  OTAFlightCancelOrder.h
//  Test
//
//  Created by Boyi on 3/10/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAFlightCancelOrder : NSObject

/**
 *  用户UID
 */
@property (nonatomic, strong) NSString *uniqueUID;

/**
 *  订单号列表：Int类型；必填
 */
@property (nonatomic, strong) NSArray *orderIDs;

/**
 *  根据订单号信息生成对应取消订单xml的请求body
 *
 *  @return 取消订单xml的请求body
 */
- (NSString *)generateOTAFlightCancelOrderXMLRequest;

@end
