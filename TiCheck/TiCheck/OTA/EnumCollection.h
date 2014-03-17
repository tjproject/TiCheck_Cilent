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

typedef NS_ENUM(NSUInteger, ClassGrade) {
    Y,
    C,
    F
};

typedef NS_ENUM(NSUInteger, PriceType) {
    NormalPrice,
    SingleTripPrice,
    CZSpecialPrice // 南航特价
};

typedef NS_ENUM(NSUInteger, ProductType) {
    Normal,
    YoungMan,
    OldMan
};

#pragma mark OTA_FlightSearch

typedef NS_ENUM(NSUInteger, FlightSearchType) {
    S,
    R,
    M
};

typedef NS_ENUM(NSUInteger, OrderCriterion) {
    DepartTime,
    TakeOffTime,
    Price,
    Rate,
    LowPrice
};

typedef NS_ENUM(NSUInteger, OrderDirection) {
    ASC,
    Desc
};

#pragma mark OTA_FlightSaveOrder

typedef NS_ENUM(NSUInteger, AgeType) {
    ADU,
    CHI,
    BAB
};

// 联系人确认方式
typedef NS_ENUM(NSUInteger, ConfirmOption) {
    TEL,
    EML
};

// 配送方式：PJS 邮寄行程单，PJN 不需要
typedef NS_ENUM(NSUInteger, DeliveryType) {
    PJS,
    PJN
};

// 产品来源：string类型；必填；两程航班必填1：携程机票频道，2：共享平台，3：兼有两程时，4：直连产品，只有一程是共享平台不可预订
typedef NS_ENUM(NSUInteger, ProductSource) {
    LargeSystem = 1,
    SharedPlatform = 2,
    Both = 3,
    Direct = 4
};

// 库存类型：string类型；必填；两程航班必填FIX:定额 FAV :见舱 两程时一程见舱一程定额不可预定
typedef NS_ENUM(NSUInteger, InventoryType) {
    FIX,
    FAV
};

// 证件类型ID：Int类型；必填：1身份证，2护照，4军人证，7回乡证，8台胞证，10港澳通行证，11国际海员证，20外国人永久居留证，25户口簿，27出生证明，99其它
typedef NS_ENUM(NSUInteger, PassportType) {
    ID = 1,
    Passport = 2,
    Military = 4,
    HomeReturePermit = 7,
    TaiWaner = 8,
    HongKongAndMacaoPermit = 10,
    InternationalSeaman = 11,
    GreenCard = 20,
    Booklet = 25,
    BirthCertificate = 27,
    Other = 99
};

#pragma mark OTA_FlightOrderList

// 订单状态：Int类型；0全部订单，8未提交，1未处理，2 处理状态，3已成交，4已取消，5全部退票，6部分退票
typedef NS_ENUM(NSUInteger, OrderStatus) {
    AllOrders = 0,
    Uncommitted = 8,
    Unprocessed = 1,
    Processing = 2,
    Deal = 3,
    Cancelled = 4,
    AllRefund = 5,
    PartRefund = 6
};

// 订单分类：D国内机票，I国际机票
typedef NS_ENUM(NSUInteger, FlightOrderClass) {
    Domestic,
    International
};

typedef NS_ENUM(NSUInteger, Gender) {
    Male,
    Female
};
#endif
