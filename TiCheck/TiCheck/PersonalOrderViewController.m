//
//  PersonalOrderViewController.m
//  TiCheck
//
//  Created by 大畅 on 14-4-17.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PersonalOrderViewController.h"
#import "PersonalOrderTableViewCell.h"
#import "OrderInfoViewController.h"
#import "ServerCommunicator.h"

#import "APIResourceHelper.h"
#import "Order.h"
#import "Flight.h"
#import "CraftType.h"

#import "NSDate-Utilities.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"

@interface PersonalOrderViewController ()
{
    NSMutableArray *orderList;
}
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
    [self initOrderData];
    [self initVessel];
}

- (void)initOrderData
{
    //get order from server
    NSDictionary *returnDic = [[ServerCommunicator sharedCommunicator] getOrderInfo:nil];
    NSInteger returnCode = [returnDic[SERVER_RETURN_CODE_KEY] integerValue];
    
    orderList = [[NSMutableArray alloc] init];
    if(returnCode == USER_LOGIN_SUCCESS)
    {
        orderList = [Order orderWithDiscitionary:returnDic];
    }
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
    return orderList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PersonalOrderCellIdentifier";
    PersonalOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[PersonalOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        CraftType *tempCT = [[APIResourceHelper sharedResourceHelper] findCraftTypeViaCT:[[[[orderList objectAtIndex:indexPath.row] flightsList] objectAtIndex:0] craftType]];
        [cell initOrderInfoWithFlight:[NSString stringWithFormat:@"%@%@",[[[[orderList objectAtIndex:indexPath.row] flightsList] objectAtIndex:0] airlineShortName],[[[[orderList objectAtIndex:indexPath.row] flightsList] objectAtIndex:0] flightNumber]] Plane:[NSString stringWithFormat:@"%@ %@",[tempCT craftKindShowingOnResultInTicketInfo],[NSString classGradeToChinese:[[[[orderList objectAtIndex:indexPath.row] flightsList] objectAtIndex:0] classGrade]]] Time:[[NSString stringWithFormat:@"%@",[[[[orderList objectAtIndex:indexPath.row] flightsList] objectAtIndex:0] takeOffTime]] stringByReplacingOccurrencesOfString:@"+0000" withString:@""] Place:[NSString stringWithFormat:@"%@-%@",[[[[orderList objectAtIndex:indexPath.row] flightsList] objectAtIndex:0] departPortShortName],[[[[orderList objectAtIndex:indexPath.row] flightsList] objectAtIndex:0] arrivePortShortName]] FlightImage:[UIImage imageNamed:[[[[orderList objectAtIndex:indexPath.row] flightsList] objectAtIndex:0] airlineDibitCode]]];
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
    OrderInfoViewController *tiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderInfoViewController"];
    tiVC.OIVC_Order = [orderList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:tiVC animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
