//
//  OrderInfoViewController.h
//  TiCheck
//
//  Created by 大畅 on 14-4-14.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OIVCPassengerInfoView.h"
#import <PassKit/PKAddPassesViewController.h>

@class Order;

@interface OrderInfoViewController : UIViewController<PKAddPassesViewControllerDelegate>
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

@property NSInteger segueFromOnlinePayTag;
@property (strong, nonatomic) Order *OIVC_Order;
@property (strong, nonatomic) NSDate *OIVC_departureDate;

@end
