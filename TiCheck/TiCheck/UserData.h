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

-(BOOL) loginWithAccout:(NSString*)account andPassword:(NSString*)password;

@end
