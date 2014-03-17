//
//  OTAUserUniqueIDResponse.h
//  Test
//
//  Created by Boyi on 3/17/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAResponse.h"

@interface OTAUserUniqueIDResponse : OTAResponse

/**
 *  用户关联标识
 */
@property (nonatomic, strong) NSString *uniqueUID;

/**
 *  响应码。0表示成功，其他表示失败
 */
@property (nonatomic) NSInteger retCode;

/**
 *  相应类型。0表示新生成的用户，1表示已存在的用户
 */
@property (nonatomic) NSInteger operationType;

/**
 *  根据返回的xml初始化OTAUserUniqueIDResponse
 *
 *  @param xml 返回的xml
 *
 *  @return 初始化后的对象自身
 */
- (id)initWithOTAUserUniqueIDResponse:(NSString *)xml;

@end
