//
//  Passenger.h
//  Test
//
//  Created by Boyi on 3/11/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumCollection.h"
#import "Contact.h"

#define SERVER_NAME_KEY @"PassengerName"
#define SERVER_BIRTHDAY_KEY @"Birthday"
#define SERVER_PASSPORTTYPE_KEY @"PassType"
#define SERVER_PASSPORTNUMBER_KEY @"PassportNumber"
#define SERVER_TELPHONE_KEY @"ContactTelephone"
#define SERVER_GENDER_KEY @"Gender"

@interface Passenger : NSObject

/**
 *  联系人
 */
@property (nonatomic, strong) Contact *contact;

///**
// *  联系人姓名：string类型；必填
// */
//@property (nonatomic, strong) NSString *contactName;
//
///**
// *  联系人确认方式：string类型；必填；电话确认TEL，邮件确认EML
// */
//@property (nonatomic) ConfirmOption confirmOption;
//
///**
// *  联系手机号码(国内) ：string类型；必填
// */
//@property (nonatomic, strong) NSString *mobilePhone;
//
///**
// *  联系电话：string类型；必填
// */
//@property (nonatomic, strong) NSString *contactTel;
//
///**
// *  境外手机号码：string类型；可空
// */
//@property (nonatomic, strong) NSString *foreignMobile;
//
///**
// *  境外手机前缀：string类型；可空
// */
//@property (nonatomic, strong) NSString *mobileCountryFix;
//
///**
// *  联系邮件地址：string类型；必填
// */
//@property (nonatomic, strong) NSString *contactEmail;
//
///**
// *  联系传真号码：string类型；可空
// */
//@property (nonatomic, strong) NSString *contactFax;

/**
 *  乘机人姓名：string类型；必填
 */
@property (nonatomic, strong) NSString *passengerName;

/**
 *  乘机人姓名拼音
 */
@property (nonatomic, strong) NSString *passengerNamePY;

/**
 *  乘机人出生日期：DateTime类型；必填；yyyy-MM-dd
 */
@property (nonatomic, strong) NSDate *birthDay;

/**
 *  证件类型ID：Int类型；必填：1身份证，2护照，4军人证，7回乡证，8台胞证，10港澳通行证，11国际海员证，20外国人永久居留证，25户口簿，27出生证明，99其它
 */
@property (nonatomic) PassportType passportType;

/**
 *  证件名称，如‘护照’
 */
@property (nonatomic, strong) NSString *cardTypeName;

/**
 *  证件号码：string类型；必填
 */
@property (nonatomic, strong) NSString *passportNumber;

/**
 *  乘机人联系电话：string类型；必填
 */
@property (nonatomic, strong) NSString *contactTelephone;

/**
 *  乘机人性别
 */
@property (nonatomic) Gender gender;

/**
 *  国家代码：string类型；必填
 */
@property (nonatomic, strong) NSString *nationalityCode;

/**
 *  国家名称
 */
@property (nonatomic, strong) NSString *nationalityName;

/**
 *  证件有效期
 */
@property (nonatomic, strong) NSDate *cardValid;

/**
 *  携程员工填写
 */
@property (nonatomic, strong) NSString *corpEid;

/**
 *  创建并返回一个初始化的Passenger实例
 *
 *  @param name           乘机人姓名
 *  @param birthday       乘机人出生日期
 *  @param passportType   证件类型
 *  @param passportNumber 证件号
 *
 *  @return Passenger实例
 */
+ (Passenger *)passengerWithPassengerName:(NSString *)name
                                 birthDay:(NSDate *)birthday
                             passportType:(PassportType)passportType
                               passportNo:(NSString *)passportNumber;

/**
 *  通过字典创建实例
 *
 *  @param dictionary 字典
 *
 *  @return 实例
 */
+ (Passenger *)createPassengerWithDictionary:(NSDictionary *)dictionary;

/**
 *  通过服务器返回数据字典创建实例
 *
 *  @param dictionary 字典
 *
 *  @return 实例
 */
+ (Passenger *)createPassengerByServerData:(NSDictionary *)dictionary;


/**
 *  将实例转化为 dictionary
 *
 *  @return 字典
 */
- (NSDictionary *)dictionaryWithPassengerOption;

@end
