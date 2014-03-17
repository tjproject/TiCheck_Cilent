//
//  OTAFlightSearch.h
//  Test
//
//  Created by Boyi on 3/3/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumCollection.h"

@interface OTAFlightSearch : NSObject

/**
 *  航程类型：string类型；必填；S（单程）D（往返程）M（联程）
 */
@property (nonatomic) FlightSearchType searchType;

/**
 *  出发城市：目前仅支持城市三字码 如北京：BJS，上海：SHA
 */
@property (nonatomic, strong) NSString *departCity;

/**
 *  到达城市：目前仅支持城市三字码 如北京：BJS，上海：SHA
 */
@property (nonatomic, strong) NSString *arriveCity;

/**
 *  出发日期：<yyyy>-<MM>-<dd>（或<yyyy>-<MM>-<dd>T<hh>:<mm>:<ss>）格式日期
 */
@property (nonatomic, strong) NSDate *departDate;

/**
 *  航空公司二字码
 */
@property (nonatomic, strong) NSString *airline;

/**
 *  出发机场三字码 上海：SHA 或 PVG
 */
@property (nonatomic, strong) NSString *departPort;

/**
 *  到达机场三字码 北京：PEK 或 NAY
 */
@property (nonatomic, strong) NSString *arrivePort;

/**
 *  最早起飞时间 2013-05-20T08：00：00
 */
@property (nonatomic, strong) NSDate *earliestDepartTime;

/**
 *  最晚起飞时间 2013-05-20T12：00：00
 */
@property (nonatomic, strong) NSDate *latestDepartTime;

/**
 *  送票城市：string类型；可空；缺省默认出发城市
 */
@property (nonatomic, strong) NSString *sendTicketCity;

/**
 *  返回简单响应（历史版本使用过，非常规请求项）.默认为false
 */
@property (nonatomic) BOOL isSimpleResponse;

/**
 *  是否只返回每个航班最低价记录
 */
@property (nonatomic) BOOL isLowestPrice;

/**
 *  产品价格类型筛选选项 NormalPrice：普通政策, SingleTripPrice：提前预售特价
 */
@property (nonatomic) PriceType priceTypeOptions;

/**
 *  产品类型筛选选项 Normal：普通，YoungMan：青年特价，OldMan：老年特价
 */
@property (nonatomic) ProductType productTypeOptions;

/**
 *  Y：经济舱, C：公务舱, F：头等舱
 */
@property (nonatomic) ClassGrade classGrade;

/**
 *  响应排序方式 DepartTime/TakeOffTime：起飞时间排序（舱位按价格次之），Price：按价格排序（时间次之），Rate：折扣优先（时间次之），LowPrice： 低价单一排序
 */
@property (nonatomic) OrderCriterion orderBy;

/**
 *  响应排序方向 ASC：升序，Desc：降序
 */
@property (nonatomic) OrderDirection orderDirection;

/**
 *  根据当前的FlightSearch信息生成对应xml请求body
 *
 *  @return 机票搜索请求xml的Body
 */
- (NSString *)generateOTAFlightSearchXMLRequest;

@end
