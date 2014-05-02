//
//  ServerRequest.h
//  TiCheck
//
//  Created by Boyi on 4/28/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;

typedef NS_ENUM(NSInteger, ServerUserRequestType) {
    Create_User = 0,
    Modify_User,
    User_Login,
    Add_Token,
    Remove_Token
};

typedef NS_ENUM(NSInteger, ServerSubscriptionRequestType) {
    Create_Subscription = 0,
    Cancel_Subscription,
    Modify_Subscription
};

@interface ServerRequest : NSObject

/**
 *  同步获取用户相关请求返回字符串
 *
 *  @param serverUrl       请求服务器url
 *  @param userRequestType 用户请求类型
 *  @param jsonData        请求的json数据
 *
 *  @return 请求返回数据
 */
+ (NSData *)getServerUserResponseWithServerURL:(NSString *)serverUrl
                                     requestType:(ServerUserRequestType)userRequestType
                                        jsonData:(NSData *)jsonData;

/**
 *  同步获取订阅相关请求字符串
 *
 *  @param serverUrl               请求服务器url
 *  @param subscriptionRequestType 订阅请求类型
 *  @param jsonData                请求的json数据
 *
 *  @return 请求返回数据
 */
+ (NSData *)getServerSubscriptionResponseWithServerURL:(NSString *)serverUrl
                                             requestType:(ServerSubscriptionRequestType)subscriptionRequestType
                                                jsonData:(NSData *)jsonData;

@end
