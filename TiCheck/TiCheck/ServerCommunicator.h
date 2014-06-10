//
//  ServerCommunicator.h
//  TiCheck
//
//  Created by Boyi on 4/28/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
#import "Passenger.h"
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
@class Order;
@class Airline;
@interface ServerCommunicator : NSObject

/**
 *  单例
 *
 *  @return 单例
 */
+ (ServerCommunicator *)sharedCommunicator;

#pragma mark - User
/**
 *  创建用户
 *
 *  @param email    用户邮箱
 *  @param password 用户密码
 *  @param account  用户账户名
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)createUserWithEmail:(NSString *)email password:(NSString *)password account:(NSString *)account uniqueID:(NSString*) uid;
/**
 *  修改用户，如果只修改某几项，其他项用UserData获取填原来的数值
 *
 *  @param newEmail    用户新邮箱
 *  @param newPassword 用户新密码
 *  @param newAccount  用户新账户名
 *  @param newAccount  新的推送设置
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)modifyUserWithEmail:(NSString *)newEmail password:(NSString *)newPassword account:(NSString *)newAccount pushable:(NSString*) newPushable;
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

#pragma mark User Device Token
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

#pragma mark - Subscription
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

#pragma mark - Order
/**
 *  添加订单
 *
 *  @param orderDetail 订单实例
 *
 *  @return 返回消息的Dictionary
 */
- (NSDictionary *)addOrder:(Order *)orderDetail;

/**
 *  获取订单列表与信息
 *
 *  @param tempOrderID NSString 可以为空，为空时，返回用户所有订单数据
 *
 *  @return 返回订单数据
 */
- (NSDictionary *)getOrderInfo:(NSString *)tempOrderID;

#pragma mark - Contact
/**
 *  添加联系人
 *
 *  @param contacts NSArray 联系人信息
 *
 *  @return 返回消息
 */
- (NSDictionary *)addContacts:(Passenger *)contact;

/**
 *  删除联系人
 *
 *  @param contacts  NSArray 联系人信息
 *
 *  @return 返回消息
 */
- (NSDictionary *)deleteContacts:(Passenger *)contact;

/**
 *  修改联系人信息
 *
 *  @param oldContact NSDictionary 旧联系人
 *  @param newContact NSDictionary 新联系人
 *
 *  @return 返回消息
 */
- (NSDictionary *)modifyContact:(Passenger *)oldContact toNewContact:(Passenger *)newContact;

/**
 *  获取联系人信息
 *
 *  @param contacts NSArray 联系人，可为空，为空时返回所有联系人信息
 *
 *  @return 返回带联系人数据字典
 */
- (NSDictionary *)getContacts:(NSArray *)contacts;

/**
 *  获得所有航空公司二字码
 *
 *  @return 含所有联系人的返回消息
 */
- (NSDictionary *)getAllAirlineCompany;

/**
 *  增加航空公司搜索计数
 *
 *  @param airline 航空公司
 *
 *  @return 返回消息
 */
- (NSDictionary *)addAirlineCount:(Airline *)airline;

@end
