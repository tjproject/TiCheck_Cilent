//
//  OTAResponse.h
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ObjectElementToString(object, element) [[[object elementsForName:element] firstObject] stringValue]

@class GDataXMLElement;

@interface OTAResponse : NSObject

/**
 *  返回的Header
 */
@property (nonatomic, strong) NSDictionary *header;

/**
 *  XML的命名空间，在initHeaderWithResponse中初始化
 */
@property (nonatomic, strong) NSDictionary *namespacesDic;

/**
 *  根据返回的xml初始化Header
 *
 *  @param xml 返回的xml
 *
 *  @return 初始化header后的对象
 */
- (id)initHeaderWithResponse:(NSString *)xml;

/**
 *  是否一次成功的请求，必须在调用了initWithOTAFlightSearchResponse之后调用才有效
 *
 *  @return 是否成功请求
 */
- (BOOL)isResponseSuccess;

/**
 *  获得xml的根元素
 *
 *  @param xml 要解析的xml
 *
 *  @return 要解析的xml的根元素
 */
- (GDataXMLElement *)getRootElement:(NSString *)xml;

@end
