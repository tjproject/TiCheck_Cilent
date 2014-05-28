//
//  PersonalOrderTableViewCell.h
//  TiCheck
//
//  Created by 大畅 on 14-4-17.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalOrderTableViewCell : UITableViewCell
{
    NSString *flightInfo;
    NSString *planeInfo;
    NSString *timeInfo;
    NSString *placeInfo;
    UIImage *flightImageName;
}
@property (strong, nonatomic) UILabel *flightLabel;
@property (strong, nonatomic) UILabel *planeLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *placeLabel;
@property (strong, nonatomic) UIImageView *flightImage;

//add image view for fight price trend by HZB
@property (strong, nonatomic) UIImageView *priceTrednImage;


- (void)initOrderInfoWithFlight:(NSString*)fInfo Plane:(NSString*)pInfo Time:(NSString*)tInfo Place:(NSString*)p2Info FlightImage:(UIImage*)fIName;

@end
