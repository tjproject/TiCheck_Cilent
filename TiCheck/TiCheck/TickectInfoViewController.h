//
//  TickectInfoViewController.h
//  TiCheck
//
//  Created by 大畅 on 14-4-11.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TickectInfoPicker.h"

@class Flight;

@interface TickectInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TickectInfoPickerDelegate, UITextFieldDelegate>
{
    UIImageView *edgeImage;
    UIImageView *lineIndicator;
    UIImageView *planeImage;
    
    UIView *darkUILayer;
    NSArray *pickerData;
    NSString *assranceInfo;
    NSString *submitInfo;
    
    UITextField *nameInputField;
    UITextField *phoneInputField;
    UITextField *addressInputField;
    UITextField *submitTitleInputField;
    NSArray *inputFieldArray;
}

/**
 *  点击搜索结果传入相应Flight数据，根据Flight初始化此界面。机型航空公司等编号或代码到名称的转换见APIResourceHelper
 */
@property (strong, nonatomic) Flight *selectFlight;
@property (nonatomic, strong) NSDictionary *searchOptionDic;
@property BOOL isShowMore;
@property (strong, nonatomic) NSDate *departureDate;

@property (strong, nonatomic) UILabel *TIVC_timeLabel;
@property (strong, nonatomic) UILabel *TIVC_fromLabel;
@property (strong, nonatomic) UILabel *TIVC_toLabel;
@property (strong, nonatomic) UILabel *TIVC_flightLabel;
@property (strong, nonatomic) UILabel *TIVC_flightTimeLabel;
@property (strong, nonatomic) UILabel *TIVC_landTimeLabel;
@property (strong, nonatomic) UILabel *TIVC_fromAirportLabel;
@property (strong, nonatomic) UILabel *TIVC_toAirportLabel;
@property (strong, nonatomic) UILabel *TIVC_ticketPriceLabel;
@property (strong, nonatomic) UILabel *TIVC_constructionPriceLabel;
@property (strong, nonatomic) UILabel *TIVC_fuelPriceLabel;
@property (strong, nonatomic) UILabel *TIVC_discountLabel;

@property (strong, nonatomic) UIImageView *TIVC_flightImage;

@property (strong, nonatomic) UIButton *TIVC_bookButton;
@property (strong, nonatomic) UIButton *TIVC_confirmButton;
@property (strong, nonatomic) UIButton *TIVC_addPassengerButton;
@property (strong, nonatomic) UIButton *TIVC_addressBookButton;

@property (strong, nonatomic) UITableView *infoVessel;
@property (strong, nonatomic) TickectInfoPicker *TIVC_assurancePicker;
@property (strong, nonatomic) TickectInfoPicker *TIVC_submitPicker;

@property (strong, nonatomic) NSMutableArray *passengerList;
@property (strong, nonatomic) NSMutableArray *cellTitleArray;

@end
