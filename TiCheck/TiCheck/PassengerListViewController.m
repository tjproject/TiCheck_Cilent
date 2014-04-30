//
//  PassengerListViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-26.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PassengerListViewController.h"
#import "PassengerEditViewController.h"
#import "Passenger.h"

#define PASSENGER_COUNT 2;
@interface PassengerListViewController ()
{
    UIButton *addButton;
}
@end

@implementation PassengerListViewController

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
    self.navigationItem.title=@"常用联系人";
    
    [self setExtraCellLineHidden:self.passengerListTableView];
    
    
    [self initAddButton];
}

- (void)initAddButton
{
    //UIButton *addButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width,cell.frame.size.height)];
    addButton=[UIButton buttonWithType:UIButtonTypeCustom];//initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 39)];
    [addButton setFrame:CGRectMake(0, 0, self.view.frame.size.width,48)];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor colorWithRed:12/255.0 green:162/255.0 blue:224/255.0 alpha:1] forState:UIControlStateNormal];
    [addButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    addButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16.f];
    
    [addButton addTarget:self action:@selector(addButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//delete useless lines
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    //[view release];
}

////after edit, reload the tableview
//- (void)animationDidStart:(CAAnimation *)anim
//{
//    [self.passengerListTableView reloadData];
//    NSLog(@"reload");
//}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return PASSENGER_COUNT;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PassengerListCell";
    static NSString *addButtoncellIdentifier = @"PassengerAddButtonCell";
    UITableViewCell *cell;
    int count=PASSENGER_COUNT;
    if(indexPath.row== count-1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:addButtoncellIdentifier];
        if (cell == nil)
        {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addButtoncellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:addButton];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.font= [UIFont fontWithName:@"Roboto-Regular" size:15.f];
        cell.textLabel.textColor=[UIColor grayColor];
        
        //
        //get name data from passengers
        //
        cell.textLabel.text=@"黄泽彪";
        
    }
    
    return cell;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PassengerEditViewController *peVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PassengerEditViewController"];
    peVC.navigationItem.title=@"修改联系人";
    [self.navigationController pushViewController:peVC animated:YES];
    
    peVC.passengerInfo=[Passenger passengerWithPassengerName:@"黄泽彪" birthDay: nil passportType:ID passportNo:@"440508199109223314"];
    peVC.navigationBarDoneItemString=@"确认修改";
}

#pragma mark - button event

- (void) addButtonFunction:(id)sender
{
    PassengerEditViewController *peVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PassengerEditViewController"];
    
    peVC.navigationItem.title=@"添加联系人";
    peVC.navigationBarDoneItemString=@"添加";
    //
    [self.navigationController pushViewController:peVC animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
