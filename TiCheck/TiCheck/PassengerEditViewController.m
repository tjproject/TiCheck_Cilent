//
//  PassengerEditViewController.m
//  TiCheck
//
//  Created by 大畅 on 14-4-22.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PassengerEditViewController.h"
#import "Passenger.h"
#import "PassengerInfoPickerCell.h"
#import "PassengerInfoTextFieldCell.h"

#define INFO_ITEM_COUNT 6;

@interface PassengerEditViewController ()

@end

@implementation PassengerEditViewController

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
    
    if(self.passengerInfo==nil)
    {
        self.passengerInfo=[[Passenger alloc] init];
    }
    else
    {
        //
    }
    
    [self.passengerInfoTableView setScrollEnabled:NO];
    [self setExtraCellLineHidden:self.passengerInfoTableView];
    
    
    
    // 添加 取消／完成按钮
    UIBarButtonItem *cancel=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonFunction:)];
    
    UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithTitle:@"确认修改" style:UIBarButtonSystemItemDone target:self action:@selector(doneButtonFunction:)];
    
    
    self.navigationItem.leftBarButtonItem=cancel;
    self.navigationItem.rightBarButtonItem=done;
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

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return INFO_ITEM_COUNT;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fieldCellIdentifier = @"TextFieldCell";
    static NSString *pickerCellIdentifier = @"PickerCell";
    
    if (indexPath.row==0)
    {
        //姓名
         PassengerInfoTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:fieldCellIdentifier];
        
        if (cell == nil) {
            cell = [[PassengerInfoTextFieldCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.inputInfoTextField.placeholder=@"姓名";
        
        return cell;
    }
    else if(indexPath.row==1)
    {
        //性别
        PassengerInfoPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier];
        
        if (cell == nil) {
            cell = [[PassengerInfoPickerCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.labelButton.text=@"性别";
        return cell;
    }
    else if(indexPath.row==2)
    {
        //出生日期
        PassengerInfoPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier];
        
        if (cell == nil) {
            cell = [[PassengerInfoPickerCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.labelButton.text=@"出生日期";
        
        return cell;
    }
    else if(indexPath.row==3)
    {
        //证件类型
        PassengerInfoPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier];
        
        if (cell == nil) {
            cell = [[PassengerInfoPickerCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.labelButton.text=@"证件类型";
        
        return cell;
    }
    else if(indexPath.row==4)
    {
        //证件号
        PassengerInfoTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:fieldCellIdentifier];
        
        if (cell == nil) {
            cell = [[PassengerInfoTextFieldCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.inputInfoTextField.placeholder=@"证件号";
        
        cell.inputInfoTextField.keyboardAppearance=UIKeyboardTypeNumbersAndPunctuation;
        
        return cell;
    }
    else if(indexPath.row==5)
    {
        //联系手机号
        PassengerInfoTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:fieldCellIdentifier];
        
        if (cell == nil) {
            cell = [[PassengerInfoTextFieldCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.inputInfoTextField.placeholder=@"联系手机";
        
        cell.inputInfoTextField.keyboardAppearance=UIKeyboardTypeNumbersAndPunctuation;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row>=1&&indexPath.row<=3)
    {
        [self pickerCellTapped:indexPath.row];
    }
}

#pragma mark - button event
- (void) pickerCellTapped:(NSInteger) index
{
    NSLog(@"test");
    if (index==1)
    {
        
    }
    else if (index==2)
    {
        
        
    }
    else if (index==3)
    {
        
    }
}

-(void) cancelButtonFunction:(id)sender
{
    
    //[self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doneButtonFunction:(id) sender
{
    [self setPassengerInfoByTableViewData:self.passengerInfoTableView];
    if ([self checkInfo:self.passengerInfo])
    {
        //alert 修改成功
        //自动返回
    }
    else
    {
        //
    }
}

- (void) setPassengerInfoByTableViewData:(UITableView*)tableView
{
    
}

- (Boolean) checkInfo:(Passenger*) passenger
{
    return NO;
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
