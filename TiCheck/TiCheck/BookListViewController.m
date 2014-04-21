//
//  BookListViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-21.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "BookListViewController.h"
#import "PersonalOrderTableViewCell.h"
#import "BookListSectionView.h"

@interface BookListViewController ()
{
    NSMutableArray* bookOrderList;
    
    NSMutableArray* isCellExpanded;
}
@end

@implementation BookListViewController

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
    // Do any additional setup after loading the view.
    //
    self.navigationItem.title=@"我的订阅";
    
    [self initBookOrderList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBookOrderList
{
    bookOrderList=[[NSMutableArray alloc]init];
    
    for(int i=0; i<4;i++)
    {
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        
        for (int j=0; j<8; j++) {
            [temp addObject: [NSString stringWithFormat:@"%i",j*i ]];
        }
        
        [bookOrderList addObject:temp];
    }
    
    
    for (int i=0; i<bookOrderList.count; i++) {
        [isCellExpanded addObject:NO];
    }
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return bookOrderList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [isCellExpanded objectAtIndex:section]? ((NSMutableArray*)[bookOrderList objectAtIndex:section]).count :3;
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    UITableViewHeaderFooterView* sectionView =  [tableView headerViewForSection:section];
//    sectionView.backgroundColor=[UIColor colorWithRed:225/255.0 green:22/255.0 blue:255/255.0 alpha:1.0];
//    
//    
//    return @"test";
//}
//- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)
//{
//    UITableViewHeaderFooterView *view=[[UITableViewHeaderFooterView alloc]init];
//    
//    //
//    view.tintColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    view.textLabel.text=@"test2";
//    
//    return view;
//}

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
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* temp=[[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 39)];
    temp.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
    
    
    UIButton* sectionButton=[UIButton buttonWithType:UIButtonTypeCustom];//initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 39)];
    [sectionButton setFrame:CGRectMake(0, 0, tableView.frame.size.width, 39)];
    
    //
    //bug: after clicked, the button title disappeared.!!!
    //
    [sectionButton setTitle:@"2013-04-13 至 2013-04-25 上海到北京" forState:UIControlStateNormal];
    
    sectionButton.titleLabel.text=@"2013-04-13 至 2013-04-25 上海到北京";
    
    //sectionButton.titleLabel.textAlignment=UITextAlignmentCenter;
    sectionButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12.f];
    sectionButton.titleLabel.textColor=[UIColor colorWithRed:12/255.0 green:162/255.0 blue:224/255.0 alpha:1];
    
    [sectionButton addTarget:self action:@selector(sectionListButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [temp addSubview:sectionButton];
    
    
    //add separator line
    UIView *separatorline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, temp.frame.size.width, 0.5 )];
    separatorline.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    [temp addSubview:separatorline];
    
    UIView *separatorline2 = [[UIView alloc] initWithFrame:CGRectMake(0, temp.frame.size.height, temp.frame.size.width, 0.5 )];
    separatorline2.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    [temp addSubview:separatorline2];

    

    return temp;
}

- (void) sectionListButton:(id)sender
{
    //
    NSLog(@"test section button");
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
