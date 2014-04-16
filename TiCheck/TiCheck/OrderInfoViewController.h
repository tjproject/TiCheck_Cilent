//
//  OrderInfoViewController.h
//  TiCheck
//
//  Created by 大畅 on 14-4-14.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OIVCPassengerInfoView.h"

@interface OrderInfoViewController : UIViewController
{
    UIScrollView *contentVessel;
    CGFloat contentSize;
    UIImageView *mainInfoBg;
    UIImageView *airlineImage;
    UILabel *timeLabel;
    UILabel *flightLabel;
    UILabel *departTimeLabel;
    UILabel *departInfoLabel;
    UILabel *arriveTimeLabel;
    UILabel *arriveInfoLabel;
    UILabel *priceLabel;
    UILabel *fuelLabel;
    UILabel *constructLabel;
    UILabel *assuranceLabel;
}
@property (strong, nonatomic) UIImageView *OIVC_successBanner;
@property (strong, nonatomic) NSMutableArray *passengerList;

@property (strong, nonatomic) UIButton *passbookButton;
@property (strong, nonatomic) UIButton *cancelButton;

@end
