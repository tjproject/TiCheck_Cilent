//
//  TickectInfoViewController.h
//  TiCheck
//
//  Created by 大畅 on 14-4-11.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TickectInfoPicker.h"

@interface TickectInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TickectInfoPickerDelegate>
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

@end
