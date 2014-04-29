//
//  ServerCommunicator.h
//  TiCheck
//
//  Created by Boyi on 4/28/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 *
 *  @return 是否成功创建
 */
- (BOOL)createUserWithEmail:(NSString *)email password:(NSString *)password;

/**
 *  修改用户
 *
 *  @param email    用户邮箱
 *  @param password 用户密码
 *  @param account  用户账户名
 *
 *  @return 是否成功修改
 */
- (BOOL)modifyUserWithEmail:(NSString *)email password:(NSString *)password account:(NSString *)account;

@end
