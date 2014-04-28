//
//  Airline.h
//  TiCheck
//
//  Created by Boyi on 4/27/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Airline : NSObject

/**
 *  航空公司二字码
 */
@property (nonatomic, strong) NSString *airline;

/**
 *  航空公司数字码
 */
@property (nonatomic, strong) NSString *airlineCode;

/**
 *  航空公司名
 */
@property (nonatomic, strong) NSString *airlineName;

/**
 *  航空公司电子名称
 */
@property (nonatomic, strong) NSString *airlineEName;

/**
 *  航空公司简称
 */
@property (nonatomic, strong) NSString *shortName;

/**
 *  组ID，不知道什么用
 */
@property (nonatomic) NSInteger groupID;

/**
 *  组名，不知道什么用
 */
@property (nonatomic, strong) NSString *groupName;

/**
 *  不知道什么东西
 */
@property (nonatomic, strong) NSString *strictType;

/**
 *  不知道
 */
@property (nonatomic) BOOL addonPriceProtected;

/**
 *  不知道
 */
@property (nonatomic) BOOL isSupportAirPlus;

/**
 *  航空公司预定链接
 */
@property (nonatomic, strong) NSString *onlineCheckinUrl;

@end
