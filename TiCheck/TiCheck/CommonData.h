//
//  CommonData.h
//  TiCheck
//
//  Created by Boyi on 4/26/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#ifndef TiCheck_CommonData_h
#define TiCheck_CommonData_h

#import <UIKit/UIKit.h>

#import "FromToTableViewCell.h"
#import "DateTableViewCell.h"
#import "DateIntervalTableViewCell.h"
#import "GeneralOptionTableViewCell.h"
#import "CitySelectViewController.h"
#import "DateSelectViewController.h"

#import "APIResourceHelper.h"
#import "NSString+DateFormat.h"
#import "NSDate-Utilities.h"

#define TOOLBAR_PICKER_ANIMATION_SPEED 0.2f

#define TABLE_VIEW_DEFAULT_HEIGHT 44.0f
#define MORE_OPTION_COUNT 4

#define SHOW_TOOL_BAR_VIEW_FRAME CGRectMake(0.0f, 362.0f, 320.0f, 44.0f)
#define HIDE_TOOL_BAR_VIEW_FRAME CGRectMake(0.0f, 568.0f, 320.0f, 44.0f)

#define SHOW_PICKER_VIEW_FRAME CGRectMake(0.0f, 406.0f, 320.0f, 162.0f)
#define HIDE_PICKER_VIEW_FRAME CGRectMake(0.0f, 612.0f, 320.0f, 162.0f)

typedef NS_ENUM(NSInteger, SelectingOption) {
    SelectingAirline,
    SelectingSeat,
    SelectingAirport,
    SelectingTakeOffTime
};

const NSArray *___airlinesName;
const NSArray *___seatType;
const NSArray *___airportsName;
const NSArray *___takeOffTimeScope;

#define cSeatTypeGet (___seatType == nil ? ___seatType = [[NSArray alloc] initWithObjects:\
@"不限",\
@"经济舱",\
@"商务舱",\
@"头等舱", nil] : ___seatType)

#define cTakeOffTimeScopeGet (___takeOffTimeScope == nil ? ___takeOffTimeScope = [[NSArray alloc] initWithObjects:\
@"不限", \
@"6:00 ~ 9:00",\
@"9:00 ~ 12:00",\
@"12:00 ~ 15:00",\
@"15:00 ~ 18:00",\
@"18:00 ~ 21:00",\
@"21:00 ~ 24:00", nil] : ___takeOffTimeScope)

#endif
