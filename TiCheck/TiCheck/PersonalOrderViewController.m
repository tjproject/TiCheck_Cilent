//
//  PersonalOrderViewController.m
//  TiCheck
//
//  Created by 大畅 on 14-4-17.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PersonalOrderViewController.h"
#import "PersonalOrderTableViewCell.h"
#import "TickectInfoViewController.h"

@interface PersonalOrderViewController ()

@end

@implementation PersonalOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
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
    _POVCVessel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 568)];
    [_POVCVessel setSeparatorInset:UIEdgeInsetsZero];
    _POVCVessel.dataSource = self;
    _POVCVessel.delegate = self;
    _POVCVessel.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [self.view addSubview:_POVCVessel];
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PersonalOrderCellIdentifier";
    PersonalOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[PersonalOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell initOrderInfoWithFlight:@"东方航空MU5137" Plane:@"320中 经济舱" Time:@"2014-03-11  07:00-09:20" Place:@"虹桥－首都" FlightImage:@"EA_Logo"];
    }
    return cell;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TickectInfoViewController *tiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TickectInfoViewController"];
    [self.navigationController pushViewController:tiVC animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
