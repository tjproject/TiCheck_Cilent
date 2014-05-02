//
//  CraftType.h
//  TiCheck
//
//  Created by Boyi on 4/16/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CraftType : NSObject

/**
 *  机型号
 */
@property (nonatomic, strong) NSString *craftType;

/**
 *  机型名
 */
@property (nonatomic, strong) NSString *ctName;

/**
 *  宽度等级
 */
@property (nonatomic, strong) NSString *widthLevel;

/**
 *  最少座位数
 */
@property (nonatomic) NSInteger minSeats;

/**
 *  最大座位数
 */
@property (nonatomic) NSInteger maxSeats;

/**
 *  说明
 */
@property (nonatomic, strong) NSString *note;

/**
 *  机型电子名
 */
@property (nonatomic, strong) NSString *ctEName;

/**
 *  机型大小
 */
@property (nonatomic, strong) NSString *craftKind;

/**
 *  获得显示的机型信息
 *
 *  @return 显示的机型信息
 */
- (NSString *)craftKindShowingOnResult;

/**
 *  获得显示的机型信息(机票结果界面)
 *
 *  @return 显示的机型信息
 */
- (NSString *)craftKindShowingOnResultInTicketInfo;

@end
