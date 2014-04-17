//
//  PersonalOrderTableViewCell.m
//  TiCheck
//
//  Created by 大畅 on 14-4-17.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PersonalOrderTableViewCell.h"

@implementation PersonalOrderTableViewCell
{
    BOOL labelInitFinished;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initLabel];
        [self initImage];
    }
    return self;
}

- (void)initLabel
{
    _flightLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 8, 120, 30)];
    _flightLabel.font = [UIFont fontWithName:@"Arial" size:15.f];
    [self addSubview:_flightLabel];
    
    _planeLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 80, 30)];
    _planeLabel.font = [UIFont fontWithName:@"Arial" size:12.f];
    _planeLabel.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.0];
    [self addSubview:_planeLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 45, 200, 30)];
    _timeLabel.font = [UIFont fontWithName:@"Roboto-Condensed" size:15.f];
    [self addSubview:_timeLabel];
    
    _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 45, 80, 30)];
    _placeLabel.font = [UIFont fontWithName:@"Arial" size:12.f];
    _placeLabel.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.0];
    [self addSubview:_placeLabel];
}

- (void)initLabelText
{
    _flightLabel.text = flightInfo;
    _planeLabel.text = planeInfo;
    _timeLabel.text = timeInfo;
    _placeLabel.text = placeInfo;
}

- (void)initImage
{
    _flightImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 20, 20)];
    [self addSubview:_flightImage];
}

- (void)initImageSource
{
    _flightImage.image = [UIImage imageNamed:flightImageName];
}

- (void)initOrderInfoWithFlight:(NSString *)fInfo Plane:(NSString *)pInfo Time:(NSString *)tInfo Place:(NSString *)p2Info FlightImage:(NSString*)fIName
{
    flightInfo = fInfo;
    planeInfo = pInfo;
    timeInfo = tInfo;
    placeInfo = p2Info;
    flightImageName = fIName;
    [self initLabelText];
    [self initImageSource];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
