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

@property (nonatomic, retain) NSString * passengerName;
@property (nonatomic, retain) NSString * passengerNamePY;
@property (nonatomic, retain) NSDate * birthDay;
@property (nonatomic, retain) NSNumber * passportType;
@property (nonatomic, retain) NSString * cardTypeName;
@property (nonatomic, retain) NSString * passportNumber;
@property (nonatomic, retain) NSString * contactTelephone;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * nationalityCode;
@property (nonatomic, retain) NSString * nationalityName;
@property (nonatomic, retain) NSDate * cardValid;
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
