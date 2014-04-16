//
//  NSString+DateFormat.h
//  Test
//
//  Created by Boyi on 3/4/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateFormat)

/**
*  获得格式为yyyy-MM-dd的日期字串
*
*  @param date 要转换的日期字串
*
*  @return 格式为yyyy-MM-dd的日期字串
*/
+ (NSString *)stringFormatWithDate:(NSDate *)date;

/**
 *  获得格式为yyyy-MM-ddTHH:mm:ss的时间字串
 *
 *  @param date 要转换的时间字串
 *
 *  @return 格式为yyyy-MM-ddTHH:mm:ss的时间字串
 */
+ (NSString *)stringFormatWithTime:(NSDate *)date;

/**
 *  根据格式为yyyy-MM-ddTHH:mm:ss的时间字串获得NSDate
 *
 *  @param timeStr 格式为yyyy-MM-ddTHH:mm:ss的时间字串
 *
 *  @return 转换后的NSDate
 */
+ (NSDate *)timeFormatWithString:(NSString *)timeStr;

/**
 *  根据格式为yyyy-MM-dd的日期字串获得NSDate
 *
 *  @param dateStr 格式为yyyy-MM-dd的日期字串
 *
 *  @return 转换后的NSDate
 */
+ (NSDate *)dateFormatWithString:(NSString *)dateStr;

/**
 *  获得格式为HH:mm的时间字串，用于搜索结果显示
 *
 *  @param date 要转换的时间
 *
 *  @return 格式为HH:mm的时间字串
 */
+ (NSString *)showingStringFormatWithString:(NSDate *)date;

@end
