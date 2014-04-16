//
//  OIVCPassengerInfoView.h
//  TiCheck
//
//  Created by 大畅 on 14-4-14.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OIVCPassengerInfoView : UIView
{
    NSString *nameString;
    NSString *idNumString;
    NSString *phoneNumString;
}
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *idNumLabel;
@property (strong, nonatomic) UILabel *phoneNumLabel;

- (void)initPassengerInfoWithName:(NSString*)name idNum:(NSString*)idNumber phoneNum:(NSString*)phoneNumber;

@end
