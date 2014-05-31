//
//  BookListViewController.h
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-21.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

-(void) initDataCount;

@property (strong, nonatomic) IBOutlet UITableView* bookListTableView;
@property (strong, nonatomic) NSMutableArray *subscriptionArray;
@property (strong, nonatomic) NSMutableArray *flightListArray;
@property (nonatomic) int dataCount;

@property (strong, nonatomic) NSDictionary *returnDic;

@end
