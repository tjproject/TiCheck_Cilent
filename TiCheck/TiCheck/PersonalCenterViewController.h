//
//  PersonalCenterViewController.h
//  TiCheck
//
//  Created by 大畅 on 14-4-17.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *PCVCVessel;

- (void)receivePushNotification:(NSDictionary *)notification;
@end
