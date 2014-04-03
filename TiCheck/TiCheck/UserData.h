//
//  UserData.h
//  TiCheck
//
//  Created by 邱峰 on 14-4-2.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject


+(UserData*) sharedUserData;

/**
 *  如果不存在 下面会返回nil
 */

/**
 *  用户账户
 */
@property (nonatomic,strong) NSString* account;

/**
 *  用户密码 已经被加密过的
 *  默认set方法是没有被加密的
 */
@property (nonatomic,strong) NSString* password;

/**
 *  用户邮箱
 */
@property (nonatomic,strong) NSString* email;

/**
 *  与后台连接 登录账号
 *
 *  @param account        账号
 *  @param password       密码
 *  @param viewController viewcontroller 方便直接push跳转
 *
 *  @return 成功返回YES 失败返回NO
 */
-(BOOL) loginWithAccout:(NSString*)account andPassword:(NSString*)password inViewController:(UIViewController*)viewController;

/**
 *  自动登录
 *
 *  @param viewController 所在的viewController 方便push
 *
 *  @return  成功返回YES 失败返回NO
 */
-(BOOL) autoLoginInViewController:(UIViewController*)viewController;

@end
