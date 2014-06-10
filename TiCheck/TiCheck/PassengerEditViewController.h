//
//  PassengerEditViewController.h
//  TiCheck
//
//  Created by 大畅 on 14-4-22.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Passenger.h"
#import "TickectInfoPicker.h"
@interface PassengerEditViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,TickectInfoPickerDelegate, UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *passengerInfoTableView;

//保存原有信息
@property (strong, nonatomic) Passenger *oldPassengerInfo;

//the new one
@property (strong, nonatomic) Passenger *passengerInfo;

@property (strong, nonatomic) NSString *navigationBarDoneItemString;

@property (nonatomic) BOOL isDirectlyBackToTicketInfo;

@end
