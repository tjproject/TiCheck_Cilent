//
//  PersonalOrderViewController.h
//  TiCheck
//
//  Created by 大畅 on 14-4-17.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoViewController.h"

@interface PersonalOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,OrderInfoViewDelegate>

@property (strong, nonatomic) UITableView *POVCVessel;

@end
