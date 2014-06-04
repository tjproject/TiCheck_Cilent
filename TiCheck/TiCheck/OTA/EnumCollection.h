//
//  EnumCollection.h
//  Test
//
//  Created by Boyi on 3/5/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#ifndef Test_EnumCollection_h
#define Test_EnumCollection_h

#pragma mark Common

/**
 *  舱位
 */
typedef NS_ENUM(NSUInteger, ClassGrade) {
    /**
     *  经济舱
     */
    Y,
    /**
     *  公务舱
     */
    C,
    /**
     *  头等舱
     */
    F
};

/**
 *  产品价格类型筛选选项
 */
typedef NS_ENUM(NSUInteger, PriceType) {
    /**
     *  普通政策
     */
    NormalPrice,
    /**
     *  提前预售特价
     */
    SingleTripPrice,
    /**
     *  南航特价
     */
    CZSpecialPrice
};

/**
 *  机票产品类型
 */
typedef NS_ENUM(NSUInteger, ProductType) {
    /**
     *  正常
     */
    Normal,
    /**
     *  年轻人
     */
    YoungMan,
    /**
     *  老年人
     */
    OldMan
};

#pragma mark OTA_FlightSearch

/**
 *  航程类型
 */
typedef NS_ENUM(NSUInteger, FlightSearchType) {
    /**
     *  单程
     */
    S,
    /**
     *  往返程
     */
    R,
    /**
     *  联程
     */
    M
};

/**
 *  响应排序方式
 */
typedef NS_ENUM(NSUInteger, OrderCriterion) {
    /**
     *  起飞时间排序（舱位按价格次之）
     */
    DepartTime,
    /**
     *  起飞时间排序（舱位按价格次之）,
     */
    TakeOffTime,
    /**
     *  按价格排序（时间次之）
     */
    Price,
    /**
     *  折扣优先（时间次之）
     */
    Rate,
    /**
     *  低价单一排序
     */
    LowPrice
};

typedef NS_ENUM(NSUInteger, OrderDirection) {
    ASC,
    Desc
};

#pragma mark OTA_FlightSaveOrder

/**
 *  乘客年龄类型
 */
typedef NS_ENUM(NSUInteger, AgeType) {
    /**
     *  成人
     */
    ADU,
    /**
     *  儿童
     */
    CHI,
    /**
     *  婴儿
     */
    BAB
};

/**
 *  联系人确认方式
 */
typedef NS_ENUM(NSUInteger, ConfirmOption) {
    /**
     *  电话
     */
    TEL,
    /**
     *  邮箱
     */
    EML
};

// 配送方式：PJS 邮寄行程单，PJN 不需要
typedef NS_ENUM(NSUInteger, DeliveryType) {
    PJS,
    PJN
};


/**
 *  产品来源：string类型；必填；两程航班必填1：携程机票频道，2：共享平台，3：兼有两程时，4：直连产品，只有一程是共享平台不可预订
 */
typedef NS_ENUM(NSUInteger, ProductSource) {
    /**
     *  携程机票频道
     */
    LargeSystem = 1,
    /**
     *  共享平台
     */
    SharedPlatform = 2,
    /**
     *  兼有两程时
     */
    Both = 3,
    /**
     *  直连产品，只有一程是共享平台不可预订
     */
    Direct = 4
};

// 库存类型：string类型；必填；两程航班必填FIX:定额 FAV :见舱 两程时一程见舱一程定额不可预定
typedef NS_ENUM(NSUInteger, InventoryType) {
    FIX,
    FAV
};

/**
 *   证件类型ID：Int类型；必填：1身份证，2护照，4军人证，7回乡证，8台胞证，10港澳通行证，11国际海员证，20外国人永久居留证，25户口簿，27出生证明，99其它
 */
typedef NS_ENUM(NSUInteger, PassportType) {
    /**
     *  身份证
     */
    ID = 1,
    /**
     *  护照
     */
    Passport = 2,
    /**
     *  军人证
     */
    Military = 4,
    /**
     *  回乡证
     */
    HomeReturePermit = 7,
    /**
     *  台胞证
     */
    TaiWaner = 8,
    /**
     *  港澳通行证
     */
    HongKongAndMacaoPermit = 10,
    /**
     *  国际海员证
     */
    InternationalSeaman = 11,
    /**
     *  外国人永久居留证
     */
    GreenCard = 20,
    /**
     *  户口簿
     */
    Booklet = 25,
    /**
     *  出生证明
     */
    BirthCertificate = 27,
    /**
     *  其它
     */
    Other = 99
};

#pragma mark OTA_FlightOrderList

/**
 *  订单状态：Int类型；0全部订单，8未提交，1未处理，2 处理状态，3已成交，4已取消，5全部退票，6部分退票
 */
typedef NS_ENUM(NSUInteger, OrderStatus) {
    /**
     *  全部订单
     */
    AllOrders = 0,
    /**
     *  未提交
     */
    Uncommitted = 8,
    /**
     *  未处理
     */
    Unprocessed = 1,
    /**
     *  处理状态
     */
    Processing = 2,
    /**
     *  已成交
     */
    Deal = 3,
    /**
     *  已取消
     */
    Cancelled = 4,
    /**
     *  全部退票
     */
    AllRefund = 5,
    /**
     *  部分退票
     */
    PartRefund = 6
};

/**
 *   订单分类：D国内机票，I国际机票
 */
typedef NS_ENUM(NSUInteger, FlightOrderClass) {
    /**
     *  国内机票
     */
    Domestic,
    /**
     *  国际机票
     */
    International
};

typedef NS_ENUM(NSUInteger, Gender) {
    Male = 1,
    Female = 2
};
#endif
