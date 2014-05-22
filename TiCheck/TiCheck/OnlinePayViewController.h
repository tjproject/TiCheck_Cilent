//
//  OnlinePayViewController.h
//  TiCheck
//
//  Created by Boyi on 4/22/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
@interface OnlinePayViewController : UIViewController


@property (strong, nonatomic) Order *flightOrder;
@property (strong, nonatomic) NSDate *departureDate;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *tempOrderID;
@end
