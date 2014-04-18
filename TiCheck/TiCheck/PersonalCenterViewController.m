//
//  PersonalCenterViewController.m
//  TiCheck
//
//  Created by 大畅 on 14-4-17.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "AccountEditViewController.h"
#import "PersonalOrderViewController.h"

@interface PersonalCenterViewController ()

@end

@implementation PersonalCenterViewController

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
    [self initVessel];
}

- (void)initVessel
{
    _PCVCVessel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 568)];
    _PCVCVessel.dataSource = self;
    _PCVCVessel.delegate = self;
    _PCVCVessel.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [_PCVCVessel setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_PCVCVessel];
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0? 4:3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *s1CellTitleArray = [NSArray arrayWithObjects:@"账号",@"未出行订单",@"全部订单",@"我订阅的机票", nil];
    NSArray *s2CellTitleArray = [NSArray arrayWithObjects:@"常用联系人",@"通知推送",@"关于Ticheck",nil];
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) cell.textLabel.text = [s1CellTitleArray objectAtIndex:indexPath.row];
    else cell.textLabel.text = [s2CellTitleArray objectAtIndex:indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) cell.detailTextLabel.text = @"蜗壳";
    else if(indexPath.section == 0 && indexPath.row == 3) [self initBookNotificationBackgroundOnView:cell];
    else if(indexPath.section == 1 && indexPath.row == 1) [self initNotificationTriggerOnView:cell];
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.05 green:0.64 blue:0.88 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!((indexPath.section==1 && indexPath.row==1) || (indexPath.section==0 && indexPath.row==3))) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) return 35;
    else return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *UIFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIFooterView.backgroundColor = [UIColor whiteColor];
    return UIFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        AccountEditViewController *aeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountEditViewController"];
        [self.navigationController pushViewController:aeVC animated:YES];
    }
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        PersonalOrderViewController *poVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalOrderViewController"];
        [self.navigationController pushViewController:poVC animated:YES];
    }
    else if(indexPath.section == 0 && indexPath.row == 2)
    {
        PersonalOrderViewController *poVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalOrderViewController"];
        [self.navigationController pushViewController:poVC animated:YES];
    }
}

#pragma mark - utilities
- (void)initNotificationTriggerOnView:(UIView*)view
{
    UISwitch *ntfTrigger = [[UISwitch alloc] initWithFrame:CGRectMake(260, 10, 60, 30)];
    [view addSubview:ntfTrigger];
    [view bringSubviewToFront:ntfTrigger];
}

- (void)initBookNotificationBackgroundOnView:(UIView*)view
{
    UIImageView *bookNtfBg = [[UIImageView alloc] initWithFrame:CGRectMake(285, 10, 24, 24)];
    bookNtfBg.image = [UIImage imageNamed:@"PersonalBookNtfBG"];
    UILabel *bookNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(293, 10, 24, 24)];
    bookNumLabel.text = @"3";
    bookNumLabel.textColor = [UIColor whiteColor];
    bookNumLabel.font = [UIFont fontWithName:@"Roboto-Condensed" size:13.f];
    [view addSubview:bookNtfBg];
    [view addSubview:bookNumLabel];
    [view bringSubviewToFront:bookNumLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
