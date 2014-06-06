//
//  PrintObject.h
//  mgen_viewHierarchy
//
//  Created by MgenLiu on 13-9-27.
//  Copyright (c) 2013年 Mgen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintObject : NSObject
/**
 *  通过对象返回一个NSDictionary，键是属性名称，值是属性值。

 *
 *  @param obj 需要转换为字典的对象
 *
 *  @return 结果字典
 */+ (NSDictionary*)getObjectData:(id)obj;

/**
 *  将getObjectData方法返回的NSDictionary转化成JSON
 *
 *  @param obj     需要转换为json数据的对象
 *  @param options Options for creating the JSON data.
 See “NSJSONWritingOptions” for possible values. Pass 0 to specify no options.
 *  @param error   If an internal error occurs, upon return contains an NSError object that describes the problem.
 *
 *  @return JSON data for obj, or nil if an internal error occurs. The resulting data is a encoded in   UTF-8.
 */
+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

/**
 *  直接通过NSLog输出getObjectData方法返回的NSDictionary，测试用
 *
 *  @param obj 结果字典
 */
+ (void)print:(id)obj;

/**
 *  通过数据返回相应的实例
 *
 *  @param object     需要返回的实例
 *  @param dictionary 填入实例的数据
 *
 *  @return 实例
 */
+ (id)getObject:(id)object WithData:(NSDictionary *)dictionary;

@end
