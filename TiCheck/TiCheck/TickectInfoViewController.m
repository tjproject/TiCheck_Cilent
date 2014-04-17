//
//  TickectInfoViewController.m
//  TiCheck
//
//  Created by 大畅 on 14-4-11.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "TickectInfoViewController.h"
#import "PayProcessViewController.h"
#define CELL_BUTTON_RECT CGRectMake(285, 13, 23, 22)

@interface TickectInfoViewController ()
{
    NSArray *cellTitleArr;
}
@end

@implementation TickectInfoViewController

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
    [self initLabel];
    [self initImage];
    [self initButton];
    [self initCellButton];
    [self initInfoVessel];
}

- (void)initLabel
{
    _TIVC_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 68, 140, 30)];
    _TIVC_timeLabel.text = @"2014年3月11日 周二";
    _TIVC_fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 68, 60, 30)];
    _TIVC_fromLabel.text = @"上海";
    _TIVC_toLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 68, 68, 30)];
    _TIVC_toLabel.text = @"到 北京";
    _TIVC_flightLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 100, 280, 30)];
    _TIVC_flightLabel.text = @"东方航空MU5137 330大型机 经济舱";
    
    _TIVC_flightTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 170, 100, 50)];
    _TIVC_flightTimeLabel.text = @"07:00";
    _TIVC_landTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(223, 170, 100, 50)];
    _TIVC_landTimeLabel.text = @"09:20";
    
    _TIVC_fromAirportLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 180, 50, 25)];
    _TIVC_fromAirportLabel.text = @"虹桥T1";
    _TIVC_toAirportLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 180, 50, 25)];
    _TIVC_toAirportLabel.text = @"首都T2";
    
    _TIVC_ticketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 232, 50, 25)];
    _TIVC_ticketPriceLabel.text = @"¥399";
    _TIVC_constructionPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 235, 50, 25)];
    _TIVC_constructionPriceLabel.text = @"¥50";
    _TIVC_fuelPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 235, 50, 25)];
    _TIVC_fuelPriceLabel.text = @"¥120";
    _TIVC_discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 232, 50, 25)];
    _TIVC_discountLabel.text = @"3.9折";
    
    _TIVC_timeLabel.font = _TIVC_fromLabel.font = _TIVC_toLabel.font = _TIVC_flightLabel.font = [UIFont fontWithName:@"Arial" size:15.f];
    _TIVC_fromAirportLabel.font = _TIVC_toAirportLabel.font = _TIVC_discountLabel.font = [UIFont fontWithName:@"Arial" size:13.f];
    _TIVC_fromAirportLabel.textColor = _TIVC_toAirportLabel.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.0];
    _TIVC_flightTimeLabel.font = _TIVC_landTimeLabel.font = [UIFont fontWithName:@"Roboto-BoldCondensed" size:35.f];
    _TIVC_ticketPriceLabel.font = [UIFont fontWithName:@"Roboto-Condensed" size:24.f];
    _TIVC_constructionPriceLabel.font = _TIVC_fuelPriceLabel.font = [UIFont fontWithName:@"Roboto-Condensed" size:18.f];
    _TIVC_ticketPriceLabel.textColor = _TIVC_constructionPriceLabel.textColor = _TIVC_fuelPriceLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    _TIVC_discountLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:_TIVC_fromLabel];
    [self.view addSubview:_TIVC_timeLabel];
    [self.view addSubview:_TIVC_toLabel];
    [self.view addSubview:_TIVC_flightLabel];
    [self.view addSubview:_TIVC_flightTimeLabel];
    [self.view addSubview:_TIVC_landTimeLabel];
    [self.view addSubview:_TIVC_fromAirportLabel];
    [self.view addSubview:_TIVC_toAirportLabel];
    [self.view addSubview:_TIVC_ticketPriceLabel];
    [self.view addSubview:_TIVC_constructionPriceLabel];
    [self.view addSubview:_TIVC_fuelPriceLabel];
    [self.view addSubview:_TIVC_discountLabel];
    [self.view addSubview:_TIVC_discountLabel];
}


- (void)initImage
{
    _TIVC_flightImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 105, 22, 22)];
    _TIVC_flightImage.image = [UIImage imageNamed:@"EA_Logo"];
    [self.view addSubview:_TIVC_flightImage];
    
    lineIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, 320, 0.5)];
    lineIndicator.image = [UIImage imageNamed:@"lineIndicator"];
    [self.view addSubview:lineIndicator];
    
    planeImage = [[UIImageView alloc] initWithFrame:CGRectMake(151, 183, 18, 16)];
    planeImage.image = [UIImage imageNamed:@"plane"];
    [self.view addSubview:planeImage];
    
    edgeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 232, 320, 50)];
    edgeImage.image = [UIImage imageNamed:@"ticketEdge"];
    [self.view addSubview:edgeImage];
    [self.view sendSubviewToBack:edgeImage];
}

- (void)initButton
{
    _TIVC_bookButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 130, 100, 42)];
    [_TIVC_bookButton setImage:[UIImage imageNamed:@"bookButton"] forState:UIControlStateNormal];
    [_TIVC_bookButton addTarget:self action:@selector(bookButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _TIVC_confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 568-44, 320, 45)];
    [_TIVC_confirmButton setImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    [_TIVC_confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_TIVC_bookButton];
    [self.view addSubview:_TIVC_confirmButton];
    [self.view bringSubviewToFront:_TIVC_confirmButton];
}

#pragma mark - buttons in cell
- (void)initCellButton
{
    _TIVC_addPassengerButton = [[UIButton alloc] initWithFrame:CELL_BUTTON_RECT];
    _TIVC_addressBookButton = [[UIButton alloc] initWithFrame:CELL_BUTTON_RECT];
    [_TIVC_addPassengerButton setImage:[UIImage imageNamed:@"passengerButton"] forState:UIControlStateNormal];
    [_TIVC_addressBookButton setImage:[UIImage imageNamed:@"addressButton"] forState:UIControlStateNormal];
    [_TIVC_addPassengerButton addTarget:self action:@selector(addPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [_TIVC_addressBookButton addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initInfoVessel
{
    _infoVessel = [[UITableView alloc] initWithFrame:CGRectMake(0, 282, 320, 536-282-45
                                                                )];
    _infoVessel.dataSource = self;
    _infoVessel.delegate = self;
    [_infoVessel setSeparatorInset:UIEdgeInsetsZero];
    _infoVessel.scrollEnabled = NO;
    [self.view addSubview:_infoVessel];
    cellTitleArr = [NSArray arrayWithObjects:@"登机人",@"手机号码",@"航空意外险",@"报销凭证", nil];
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return 4;}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) [cell.contentView addSubview:_TIVC_addPassengerButton];
    else if(indexPath.row == 1) [cell.contentView addSubview:_TIVC_addressBookButton];
    else if(indexPath.row == 2)
    {
        cell.detailTextLabel.text = @"¥30X1份";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0 alpha:1.0];
    }
    else
    {
        cell.detailTextLabel.text = @"不需要报销凭证";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.05 green:0.64 blue:0.88 alpha:1.0];
    }
    cell.textLabel.text = [cellTitleArr objectAtIndex:[indexPath row]];
    cell.textLabel.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 48;}

#pragma mark - target selector
- (void)bookButtonPressed:(id)sender
{
    //add
}

- (void)confirmPressed:(id)sender
{
    PayProcessViewController *ppVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PayProcessViewController"];
    [self.navigationController pushViewController:ppVC animated:YES];
}

- (void)addPassenger:(id)sender
{
    //add
}

- (void)addAddress:(id)sender
{
    //add
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
