//
//  SoapRequest.h
//  Test
//
//  Created by Boyi on 3/2/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigurationHelper.h"

@class ASIHTTPRequest;

@interface SoapRequest : NSObject

/**
 *  生成SOAP1.2的ASIHTTPRequest
 *
 *  @param webURL      WebService的地址
 *  @param requestType Soap请求的API操作类型
 *  @param nameSpace   WebService的命名空间
 *  @param serviceName WebService的名称
 *  @param requestBody 请求体的xml
 *
 *  @return ASIHTTPRequest请求体
 */
+ (ASIHTTPRequest *)getASISoap12Request:(NSString *)webURL
                      flightRequestType:(FlightRequestType)requestType
                           xmlNameSpace:(NSString *)nameSpace
                         webServiceName:(NSString *)serviceName
                         xmlRequestBody:(NSString *)requestBody;

///**
// *  生成SOAP1.2的ASIHTTPRequest
// *
// *  @param webURL      WebService的地址
// *  @param fileName    WebService的访问文件名
// *  @param nameSpace   WebService的命名空间
// *  @param serviceName WebService的名称
// *  @param requestBody 请求体的xml
// *
// *  @return ASIHTTPRequest请求体
// */
//+ (ASIHTTPRequest *)getASISoap12Request:(NSString *)webURL
//                         webServiceFile:(NSString *)fileName
//                           xmlNameSpace:(NSString *)nameSpace
//                         webServiceName:(NSString *)serviceName
//                         xmlRequestBody:(NSString *)requestBody;

/**
 *  生成SOAP1.2请求并同步调用WebService，获得响应
 *
 *  @param webURL      WebService的地址
 *  @param requestType Soap请求的API操作类型
 *  @param nameSpace   WebService的命名空间
 *  @param serviceName WebService的名称
 *  @param requestBody 请求体的xml
 *
 *  @return 返回响应的字符串
 */
+ (NSString *)getSoap12WebServiceResponse:(NSString *)webURL
                        flightRequestType:(FlightRequestType)requestType
                             xmlNameSpace:(NSString *)nameSpace
                           webServiceName:(NSString *)serviceName
                           xmlRequestBody:(NSString *)requestBody;

///**
// *  生成SOAP1.2请求并同步调用WebService，获得响应
// *
// *  @param webURL      WebService的地址
// *  @param fileName    WebService的访问文件名
// *  @param nameSpace   WebService的命名空间
// *  @param serviceName WebService的名称
// *  @param requestBody 请求体的xml
// *
// *  @return 返回响应的字符串
// */
//+ (NSString *)getSoap12WebServiceResponse:(NSString *)webURL
//                           webServiceFile:(NSString *)fileName
//                             xmlNameSpace:(NSString *)nameSpace
//                           webServiceName:(NSString *)serviceName
//                           xmlRequestBody:(NSString *)requestBody;

/**
 *  生成SOAP1.1的ASIHTTPRequest
 *
 *  @param webURL      WebService的地址
 *  @param requestType Soap请求的API操作类型
 *  @param nameSpace   WebService的命名空间
 *  @param serviceName WebService的名称
 *  @param requestBody 请求体的xml
 *
 *  @return ASIHTTPRequest请求体
 */
+ (ASIHTTPRequest *)getASISoap11Request:(NSString *)webURL
                      flightRequestType:(FlightRequestType)requestType
                           xmlNameSpace:(NSString *)nameSpace
                         webServiceName:(NSString *)serviceName
                         xmlRequestBody:(NSString *)requestBody;

///**
// *  生成SOAP1.1的ASIHTTPRequest
// *
// *  @param webURL      WebService的地址
// *  @param fileName    WebService的访问文件名
// *  @param nameSpace   WebService的命名空间
// *  @param serviceName WebService的名称
// *  @param requestBody 请求体的xml
// *
// *  @return ASIHTTPRequest请求体
// */
//+ (ASIHTTPRequest *)getASISoap11Request:(NSString *)webURL
//                         webServiceFile:(NSString *)fileName
//                           xmlNameSpace:(NSString *)nameSpace
//                         webServiceName:(NSString *)serviceName
//                         xmlRequestBody:(NSString *)requestBody;

/**
 *  生成SOAP1.1请求并同步调用WebService，获得响应
 *
 *  @param webURL      WebService的地址
 *  @param requestType Soap请求的API操作类型
 *  @param nameSpace   WebService的命名空间
 *  @param serviceName WebService的名称
 *  @param requestBody 请求体的xml
 *
 *  @return 返回响应的字符串
 */
+ (NSString *)getSoap11WebServiceResponse:(NSString *)webURL
                        flightRequestType:(FlightRequestType)requestType
                             xmlNameSpace:(NSString *)nameSpace
                           webServiceName:(NSString *)serviceName
                           xmlRequestBody:(NSString *)requestBody;

///**
// *  生成SOAP1.1请求并同步调用WebService，获得响应
// *
// *  @param webURL      WebService的地址
// *  @param fileName    WebService的访问文件名
// *  @param nameSpace   WebService的命名空间
// *  @param serviceName WebService的名称
// *  @param requestBody 请求体的xml
// *
// *  @return 返回响应的字符串
// */
//+ (NSString *)getSoap11WebServiceResponse:(NSString *)webURL
//                           webServiceFile:(NSString *)fileName
//                             xmlNameSpace:(NSString *)nameSpace
//                           webServiceName:(NSString *)serviceName
//                           xmlRequestBody:(NSString *)requestBody;

@end
