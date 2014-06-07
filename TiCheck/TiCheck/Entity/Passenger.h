//
//  Passenger.h
//  TiCheck
//
//  Created by Boyi on 6/1/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EnumCollection.h"

#define SERVER_NAME_KEY @"PassengerName"
#define SERVER_BIRTHDAY_KEY @"Birthday"
#define SERVER_PASSPORTTYPE_KEY @"PassType"
#define SERVER_PASSPORTNUMBER_KEY @"PassportNumber"
#define SERVER_TELPHONE_KEY @"ContactTelephone"
#define SERVER_GENDER_KEY @"Gender"

@class Contact;


@interface Passenger : NSManagedObject

@property (nonatomic, strong) Contact *contact;

/**
 *  乘机人姓名：string类型；必填
 */
@property (nonatomic, retain) NSString * passengerName;

/**
 *  乘机人姓名拼音
 */
@property (nonatomic, retain) NSString * passengerNamePY;

/**
 *  乘机人出生日期：DateTime类型；必填；yyyy-MM-dd
 */
@property (nonatomic, retain) NSDate * birthDay;

/**
 *  证件类型ID：Int类型；必填：1身份证，2护照，4军人证，7回乡证，8台胞证，10港澳通行证，11国际海员证，20外国人永久居留证，25户口簿，27出生证明，99其它
 */
@property (nonatomic, retain) NSNumber * passportType;

/**
 *  证件名称，如‘护照’
 */
@property (nonatomic, retain) NSString * cardTypeName;

/**
 *  证件号码：string类型；必填
 */
@property (nonatomic, retain) NSString * passportNumber;

/**
 *  乘机人联系电话：string类型；必填
 */
@property (nonatomic, retain) NSString * contactTelephone;

/**
 *  乘机人性别
 */
@property (nonatomic, retain) NSNumber * gender;

/**
 *  国家代码：string类型；必填
 */
@property (nonatomic, retain) NSString * nationalityCode;

/**
 *  国家名称
 */
@property (nonatomic, retain) NSString * nationalityName;

/**
 *  证件有效期
 */
@property (nonatomic, retain) NSDate * cardValid;

/**
 *  携程员工填写
 */
@property (nonatomic, retain) NSString * corpEid;

/**
 *  创建并返回一个初始化的PassengerHelper实例
 *
 *  @param name           乘机人姓名
 *  @param birthday       乘机人出生日期
 *  @param passportType   证件类型
 *  @param passportNumber 证件号
 *
 *  @return PassengerEntity实例
 */
+ (Passenger *)passengerWithPassengerName:(NSString *)name
                                 birthday:(NSDate *)birthday
                             passportType:(PassportType)passportType
                               passportNo:(NSString *)passportNumber
                              isTemporary:(BOOL)isTemporary;

/**
 *  通过字典创建实例
 *
 *  @param dictionary 字典
 *
 *  @return 实例
 */
+ (Passenger *)createPassengerWithDictionary:(NSDictionary *)dictionary
                                 isTemporary:(BOOL)isTemporary;

/**
 *  通过服务器返回数据字典创建实例
 *
 *  @param dictionary 字典
 *
 *  @return 实例
 */
+ (Passenger *)createPassengerByServerData:(NSDictionary *)dictionary
                                isTemporary:(BOOL)isTemporary;


/**
 *  将实例转化为 dictionary
 *
 *  @return 字典
 */
- (NSDictionary *)dictionaryWithPassengerOption;

/*  通过姓名查找，失败为nil
 *
 *  @param name 查找姓名
 *
 *  @return Passenger
 */
+ (Passenger *)findPassengerWithPassengerName:(NSString *)name;

/**
 *  查找所有Passenger
 *
 *  @return 所有Passenger
 */
+ (NSArray *)findAllPassengers;

/**
 *  删除所有Passenger
 */
+ (void)deleteAllPassengers;

/**
 *  保存此Passenger
 */
- (void)savePassenger;

/**
 *  删除此Passenger
 */
- (void)deletePassenger;

@end
