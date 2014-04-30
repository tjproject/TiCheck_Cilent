//
//  ServerCommunicator.h
//  TiCheck
//
//  Created by Boyi on 4/28/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 *  @return 是否成功创建
 */
- (BOOL)createUserWithEmail:(NSString *)email password:(NSString *)password account:(NSString *)account;

/**
 *  修改用户，如果只修改某几项，其他项用UserData获取填原来的数值
 *
 *  @param newEmail    用户新邮箱
 *  @param newPassword 用户新密码
 *  @param newAccount  用户新账户名
 *
 *  @return 是否成功修改
 */
- (BOOL)modifyUserWithEmail:(NSString *)newEmail password:(NSString *)newPassword account:(NSString *)newAccount;

/**
 *  验证登录
 *
 *  @param email 用户邮箱
 *  @param password 用户密码
 *
 *  @return 是否验证成功
 */
- (BOOL)loginVerifyWithEmail:(NSString *)email password:(NSString *)password;

/**
 *  使用订阅类创建订阅
 *
 *  @param subscription 订阅类，包含订阅信息
 *
 *  @return 是否创建成功
 */
- (BOOL)createSubscriptionWithSubscription:(Subscription *)subscription;

/**
 *  将旧的订阅修改为新的
 *
 *  @param oldSubscription 旧的订阅类，包含旧的订阅信息
 *  @param newSubscription 新的订阅类，包含新的订阅信息
 *
 *  @return 是否修改成功
 */
- (BOOL)modifySubscriptionWithOldSubscription:(Subscription *)oldSubscription asNewSubscription:(Subscription *)newSubscription;

/**
 *  取消订阅
 *
 *  @param subscription 要取消的订阅类订阅信息
 *
 *  @return 是否成功取消
 */
- (BOOL)cancelSubscriptionWithSubscription:(Subscription *)subscription;

@end
