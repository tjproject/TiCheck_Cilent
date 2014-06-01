//
//  PassengerListViewController.h
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-26.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Passenger.h"
@interface PassengerListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

- (void)initPassengerListData;

@property (strong, nonatomic) IBOutlet UITableView *passengerListTableView;
@property (strong, nonatomic) NSMutableArray *passengerList;
@property BOOL isComeFromTicketPay;
@end
