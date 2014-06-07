//
//  PassengerInfoTextFieldCell.h
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-27.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassengerEditViewController.h"
@interface PassengerInfoTextFieldCell : UITableViewCell<UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UITextField* inputInfoTextField;
@property UITableView *mainTableView;
@property int cellIndex;
@end
