//
//  Airport.h
//  TiCheck
//
//  Created by Boyi on 4/16/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Airport : NSObject

/**
 *  机场三字码
 */
@property (nonatomic, strong) NSString *airportCode;

/**
 *  机场名
 */
@property (nonatomic, strong) NSString *airportName;

/**
 *  机场拼音
 */
@property (nonatomic, strong) NSString *airportEName;

/**
 *  机场简称
 */
@property (nonatomic, strong) NSString *airportShortName;

/**
 *  机场所在城市ID
 */
@property (nonatomic) NSInteger cityID;

/**
 *  机场所在城市名
 */
@property (nonatomic, strong) NSString *cityName;

@end
