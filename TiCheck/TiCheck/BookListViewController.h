//
//  BookListViewController.h
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-21.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView* bookListTableView;

@end
