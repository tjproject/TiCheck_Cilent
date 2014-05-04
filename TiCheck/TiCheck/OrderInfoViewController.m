//
//  OrderInfoViewController.m
//  TiCheck
//
//  Created by 大畅 on 14-4-14.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "OrderInfoViewController.h"
#import <PassKit/PassKit.h>
#import <PassKit/PKPassLibrary.h>

@interface OrderInfoViewController ()

@end

@implementation OrderInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initScrollView];
    [self initImageViews];
    [self initOrderInfos];
    [self initPassengerInfoViews];
    [self initButton];
}

- (void)initScrollView
{
    contentSize = [UIScreen mainScreen].bounds.size.height;
    contentVessel = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    contentVessel.contentSize = CGSizeMake(320, contentSize);
    contentVessel.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentVessel];
}

- (void)initImageViews
{
    _OIVC_successBanner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 35)];
    _OIVC_successBanner.image = [UIImage imageNamed:@"Succeed"];
    [contentVessel addSubview: _OIVC_successBanner];
    mainInfoBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 223)];
    mainInfoBg.image = [UIImage imageNamed:@"mainInfoBg"];
    [contentVessel addSubview:mainInfoBg];
}

- (void)initOrderInfos
{
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 105, 200, 30)];
    timeLabel.text = @"2014-04-14 周一";
    [contentVessel addSubview:timeLabel];
    
    airlineImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 152, 22, 22)];
    airlineImage.image = [UIImage imageNamed:@"EA_Logo"];
    [contentVessel addSubview:airlineImage];
    
    flightLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 148, 280, 30)];
    flightLabel.text = @"东方航空MU5137 330大型机 经济舱";
    flightLabel.font = [UIFont fontWithName:@"Arial" size:16.f];
    [contentVessel addSubview:flightLabel];
    
    departTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 178, 100, 50)];
    arriveTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 215, 100, 50)];
    departTimeLabel.text = @"7:00";
    arriveTimeLabel.text = @"9:25";
    departTimeLabel.font = arriveTimeLabel.font = [UIFont fontWithName:@"Roboto-BoldCondensed" size:25.f];
    [contentVessel addSubview:departTimeLabel];
    [contentVessel addSubview:arriveTimeLabel];
    
    departInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 186, 200, 30)];
    arriveInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 223, 200, 30)];
    departInfoLabel.text = @"上海虹桥机场T1航站楼 出发";
    arriveInfoLabel.text = @"首都国际机场T2航站楼 到达";
    departInfoLabel.font = arriveInfoLabel.font = [UIFont fontWithName:@"Arial" size:16.f];
    departInfoLabel.textColor = arriveInfoLabel.textColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1.0];
    [contentVessel addSubview:departInfoLabel];
    [contentVessel addSubview:arriveInfoLabel];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 283, 50, 25)];
    constructLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 283, 50, 25)];
    fuelLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 283, 50, 25)];
    priceLabel.text = @"¥399";
    constructLabel.text = @"¥50";
    fuelLabel.text = @"¥120";
    priceLabel.font = constructLabel.font = fuelLabel.font = [UIFont fontWithName:@"Roboto-Condensed" size:18.f];
    priceLabel.textColor = constructLabel.textColor = fuelLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    [contentVessel addSubview:priceLabel];
    [contentVessel addSubview:constructLabel];
    [contentVessel addSubview:fuelLabel];
    
    assuranceLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 282, 50, 25)];
    assuranceLabel.text = @"已投保";
    assuranceLabel.font = [UIFont fontWithName:@"Arial" size:13.f];
    assuranceLabel.textColor = [UIColor whiteColor];
    [contentVessel addSubview:assuranceLabel];
}

- (void)initPassengerInfoViews
{
    OIVCPassengerInfoView* passenger = [[OIVCPassengerInfoView alloc] initWithFrame:CGRectMake(0, 323, 320, 111)];
    [passenger initPassengerInfoWithName:@"刘大畅" idNum:@"120103199212012613" phoneNum:@"18917260806"];
    [_passengerList addObject:passenger];
    [contentVessel addSubview:passenger];
}

- (void)initButton
{
    _passbookButton = [[UIButton alloc] initWithFrame:CGRectMake(22.5, contentVessel.contentSize.height - 125, 275, 50)];
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(22.5, contentVessel.contentSize.height - 65, 275, 50)];
    [_passbookButton setImage:[UIImage imageNamed:@"passbookButton"] forState:UIControlStateNormal];
    [_cancelButton setImage:[UIImage imageNamed:@"cancelButton"] forState:UIControlStateNormal];
    [_passbookButton addTarget:self action:@selector(passbookPressed) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    [contentVessel addSubview:_passbookButton];
    [contentVessel addSubview:_cancelButton];
}

#pragma mark - target selector
- (void)passbookPressed
{
    NSData *passData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:@"Skyport Airways.pkpass"]];
    NSError* error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:passData error:&error];
    PKAddPassesViewController *addController = [[PKAddPassesViewController alloc] initWithPass:newPass];
    addController.delegate = self;
    [self presentViewController:addController animated:YES completion:nil];
}

- (void)cancelPressed
{
}

#pragma mark - pkaddpassviewcontroller delegate
- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
