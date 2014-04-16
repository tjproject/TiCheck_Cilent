//
//  OIVCPassengerInfoView.m
//  TiCheck
//
//  Created by 大畅 on 14-4-14.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "OIVCPassengerInfoView.h"

@implementation OIVCPassengerInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"passengerInfoBg"]];
    }
    return self;
}

- (void)initLabel
{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 3, 80, 30)];
    _nameLabel.text = nameString;
    _idNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 200, 30)];
    _idNumLabel.text = idNumString;
    _phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 66, 200, 30)];
    _phoneNumLabel.text = phoneNumString;
    _nameLabel.font = _idNumLabel.font = _phoneNumLabel.font = [UIFont fontWithName:@"Arial" size:15.f];
    _nameLabel.textColor = _idNumLabel.textColor = _phoneNumLabel.textColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1.0];
    [self addSubview:_nameLabel];
    [self addSubview:_idNumLabel];
    [self addSubview:_phoneNumLabel];
}

#pragma mark - public methods

- (void)initPassengerInfoWithName:(NSString *)name idNum:(NSString *)idNumber phoneNum:(NSString *)phoneNumber
{
    nameString = name;
    idNumString = idNumber;
    phoneNumString = phoneNumber;
    [self initLabel];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
