//
//  Contact.h
//  Test
//
//  Created by Boyi on 3/11/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumCollection.h"

@interface Contact : NSObject

/**
 *  联系人姓名：string类型；必填
 */
@property (nonatomic, strong) NSString *contactName;

/**
 *  联系人确认方式：string类型；必填；电话确认TEL，邮件确认EML
 */
@property (nonatomic) ConfirmOption confirmOption;

/**
 *  联系手机号码(国内) ：string类型；必填
 */
@property (nonatomic, strong) NSString *mobilePhone;

/**
 *  联系电话：string类型；必填
 */
@property (nonatomic, strong) NSString *contactTel;

/**
 *  境外手机号码：string类型；可空
 */
@property (nonatomic, strong) NSString *foreignMobile;

/**
 *  境外手机前缀：string类型；可空
 */
@property (nonatomic, strong) NSString *mobileCountryFix;

/**
 *  联系邮件地址：string类型；必填
 */
@property (nonatomic, strong) NSString *contactEmail;

/**
 *  联系传真号码：string类型；可空
 */
@property (nonatomic, strong) NSString *contactFax;

/**
 *  创建并返回一个初始化的Contact实例
 *
 *  @param contactName   联系人姓名
 *  @param confirmOption 联系人确认方式，默认为电话
 *  @param phoneNumber   联系人电话
 *  @param emailAddress  联系人邮箱
 *
 *  @return Contact实例
 */
+ (Contact *)contactWithContactName:(NSString *)contactName
                      confirmOption:(ConfirmOption)confirmOption
                        mobilePhone:(NSString *)phoneNumber
                       contactEmail:(NSString *)emailAddress;

@end
