//
//  PassengerEditViewController.h
//  TiCheck
//
//  Created by 大畅 on 14-4-22.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Passenger.h"
@interface PassengerEditViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *passengerInfoTableView;


@property (strong, nonatomic) Passenger *passengerInfo;

@end
