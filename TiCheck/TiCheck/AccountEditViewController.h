//
//  AccountEditViewController.h
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-9.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) IBOutlet UITableView* tableView;

@end
