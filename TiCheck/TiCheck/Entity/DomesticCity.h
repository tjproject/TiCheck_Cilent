//
//  DomesticCity.h
//  TiCheck
//
//  Created by Boyi on 4/13/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DomesticCity : NSObject

/**
 *  城市三字码
 */
@property (nonatomic, strong) NSString *cityCode;

/**
 *  城市ID
 */
@property (nonatomic) NSInteger cityID;

/**
 *  城市名
 */
@property (nonatomic, strong) NSString *cityName;

/**
 *  城市名拼音
 */
@property (nonatomic, strong) NSString *cityEName;

/**
 *  城市拼音简写（不要使用）
 */
@property (nonatomic, strong) NSString *cityShortName;

/**
 *  国家ID，实际全部为1
 */
@property (nonatomic) NSInteger countryID;

/**
 *  所在省ID
 */
@property (nonatomic) NSInteger provinceID;

/**
 *  所有机场的三字码
 */
@property (nonatomic, strong) NSArray *airports;

@end
