//
//  ServerCommunicator.h
//  TiCheck
//
//  Created by Boyi on 4/28/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_RETURN_CODE_KEY @"Code"
#define SERVER_RETURN_MESSAGE_KEY @"Message"
#define SERVER_USER_DATA @"Data"

#define USER_CREATE_SUCCESS 1
#define USER_CREATE_DUPLICATE_EMAIL 2
#define USER_CREATE_FORMAT_ERROR 3

#define USER_MODIFY_SUCCESS 1
#define USER_MODIFY_DUPLICATE_EMAIL 2
#define USER_MODIFY_NOT_EXIST 6

#define USER_LOGIN_SUCCESS 1

#define USER_INFO_SUCCESS 1

#define SUBSCRIPTION_CREATE_SUCCESS 1

#define SUBSCRIPTION_MODIFY_SUCCESS 1

#define SUBSCRIPTION_CANCEL_SUCCESS 1

@class Subscription;

@interface ServerCommunicator : NSObject

/**
 *  单例
 *
 *  @return 单例
 */
+ (ServerCommunicator *)sharedCommunicator;

/**
 *  创建用户
 *
 *  @param email    用户邮箱
 *  @param password 用户密码
 *  @param account  用户账户名
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)createUserWithEmail:(NSString *)email password:(NSString *)password account:(NSString *)account;

/**
 *  修改用户，如果只修改某几项，其他项用UserData获取填原来的数值
 *
 *  @param newEmail    用户新邮箱
 *  @param newPassword 用户新密码
 *  @param newAccount  用户新账户名
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)modifyUserWithEmail:(NSString *)newEmail password:(NSString *)newPassword account:(NSString *)newAccount;

/**
 *  验证登录
 *
 *  @param email 用户邮箱
 *  @param password 用户密码
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)loginVerifyWithEmail:(NSString *)email password:(NSString *)password;

/**
 *  返回用户信息
 *
 *  @return 用户信息
 */
- (NSDictionary *)userInfoFetch;

/**
 *  将当前用户的token添加到服务器
 *
 *  @param token 要添加的设备token
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)addTokenForCurrentUser:(NSString *)token;

/**
 *  删除当前用户的token
 *
 *  @param token 要删除的token
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)removeTokenForCurrentUser:(NSString *)token;

/**
 *  使用订阅类创建订阅
 *
 *  @param subscription 订阅类，包含订阅信息
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)createSubscriptionWithSubscription:(Subscription *)subscription;

/**
 *  将旧的订阅修改为新的
 *
 *  @param oldSubscription 旧的订阅类，包含旧的订阅信息
 *  @param newSubscription 新的订阅类，包含新的订阅信息
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)modifySubscriptionWithOldSubscription:(Subscription *)oldSubscription asNewSubscription:(Subscription *)newSubscription;

/**
 *  取消订阅
 *
 *  @param subscription 要取消的订阅类订阅信息
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)cancelSubscriptionWithSubscription:(Subscription *)subscription;


/**
 *  获取订阅
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)getSubscriptionInfo;//:(Subscription *)subscription;





@end
