//
//  PassengerListViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-26.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PassengerListViewController.h"
#import "PassengerEditViewController.h"
#import "TickectInfoViewController.h"
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
    //判断是从个人中心跳转进来还是从机票支付页面进来
    //self.isComeFromTicketPay=NO;
    
    //从个人中心跳转
    if(!self.isComeFromTicketPay)
    {
        PassengerEditViewController *peVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PassengerEditViewController"];
        peVC.navigationItem.title=@"修改联系人";
        
        //根据所选择联系人，传递联系人数据
        //
        peVC.passengerInfo=[Passenger passengerWithPassengerName:@"黄泽彪" birthday: nil passportType:ID passportNo:@"440508199109223314"];
        peVC.navigationBarDoneItemString=@"确认修改";
        
        peVC.isDirectlyBackToTicketInfo = NO;
        
        [self.navigationController pushViewController:peVC animated:YES];
    }
    //从机票支付页面跳转
    else
    {
        //根据所选择联系人返回 联系人信息 到 机票支付页面
        [self.navigationController popViewControllerAnimated:YES];
        //get the last view controller, reload table view data
        TickectInfoViewController *tiVC= (TickectInfoViewController *)[self.navigationController visibleViewController];
        
        //预先设置 乘客
        NSDateComponents *comp = [[NSDateComponents alloc]init];
        [comp setMonth:9];
        [comp setDay:22];
        [comp setYear:1991];
        NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *bDate = [myCal dateFromComponents:comp];
        
        Passenger *tempPassenger = [Passenger passengerWithPassengerName:@"黄泽彪" birthday:bDate  passportType:ID passportNo:@"440508199109223314"];
        tempPassenger.gender = [NSNumber numberWithInteger:Male];
        tempPassenger.nationalityCode = @"1";
        tempPassenger.contactTelephone = @"18817598462";
        
        
        [tiVC.passengerList addObject:tempPassenger];
        [tiVC.cellTitleArray insertObject:[NSString stringWithFormat:@"  %@",tempPassenger.passengerName] atIndex:1];
        tiVC.infoVessel.scrollEnabled = YES;
        [tiVC.infoVessel reloadData];
    }
}

#pragma mark - button event

- (void) addButtonFunction:(id)sender
{
    //判断是从个人中心跳转进来还是从机票支付页面进来
    //self.isComeFromTicketPay=NO;
    
    
    //若从机票支付页面进来，需要在填写完毕，点击添加后直接选择该联系人 并跳转回机票支付页面
    //若从个人中心进来，则返回即可
    //？或者直接统一返回联系人列表页面
    PassengerEditViewController *peVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PassengerEditViewController"];
    
    peVC.navigationItem.title=@"添加联系人";
    peVC.navigationBarDoneItemString=@"添加";
    
    //if (self.isComeFromTicketPay) {
    //设置专门的标识，使得下个页面在返回时直接跳转回机票页面
    peVC.isDirectlyBackToTicketInfo = self.isComeFromTicketPay;
    //}
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
