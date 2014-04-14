//
//  APIResourceHelper.h
//  TiCheck
//
//  Created by Boyi on 4/13/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DomesticCity;

@interface APIResourceHelper : NSObject

/**
 *  单例
 *
 *  @return 单例
 */
+ (APIResourceHelper *)sharedResourceHelper;

#pragma mark - 国内城市搜索

/**
 *  通过城市ID搜索国内城市
 *
 *  @param cityID 城市ID
 *
 *  @return 国内城市
 */
- (DomesticCity *)findDomesticCityViaID:(NSInteger)cityID;

/**
 *  通过城市三字码搜索国内城市
 *
 *  @param cityCode 城市三字码
 *
 *  @return 国内城市
 */
- (DomesticCity *)findDomesticCityViaCode:(NSString *)cityCode;

/**
 *  通过城市名搜索国内城市
 *
 *  @param cityName 城市名
 *
 *  @return 国内城市
 */
- (DomesticCity *)findDomesticCityViaName:(NSString *)cityName;

@end
