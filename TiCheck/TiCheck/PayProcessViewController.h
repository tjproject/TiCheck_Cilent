//
//  PayProcessViewController.h
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-16.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayProcessViewController : UIViewController


//ticket info label
@property (strong, nonatomic) IBOutlet UIImageView *flightLogoImage;
@property (strong, nonatomic) IBOutlet UILabel *flightNameAndIDLabel;

@property (strong, nonatomic) IBOutlet UILabel *flightDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *flightTimeLabel;
//note: from and to
@property (strong, nonatomic) IBOutlet UILabel *flightLocationLabel;

@property (strong, nonatomic) IBOutlet UILabel *flightPassengerNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *flightPriceLabel;

@end
