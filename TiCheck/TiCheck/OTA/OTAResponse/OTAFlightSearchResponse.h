//
//  OTAFlightSearchResponse.h
//  Test
//
//  Created by Boyi on 3/15/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTAResponse.h"
#import "EnumCollection.h"

@interface OTAFlightSearchResponse : OTAResponse

/**
 *  符合条件的航班数量
 */
@property (nonatomic) NSUInteger recordCount;

/**
 *  排序条件
 */
@property (nonatomic) OrderCriterion orderBy;

/**
 *  排序顺序
 */
@property (nonatomic) OrderDirection orderDirection;

/**
 *  航程列表，元素为Flight
 */
@property (nonatomic, strong) NSArray *flightsList;

/**
 *  根据返回的xml初始化OTAFlightSearchResponse
 *
 *  @param xml 返回的xml
 *
 *  @return 初始化后的对象自身
 */
- (id)initWithOTAFlightSearchResponse:(NSString *)xml;

@end
