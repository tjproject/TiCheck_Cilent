//
//  PassengerEditViewController.m
//  TiCheck
//
//  Created by 大畅 on 14-4-22.
//  Copyright (c) 2014年 tac. All rights reserved.
//
#import "PassengerListViewController.h"
#import "PassengerEditViewController.h"
#import "Passenger.h"
#import "PassengerInfoPickerCell.h"
#import "PassengerInfoTextFieldCell.h"
#import "EnumCollection.h"
#import "TickectInfoViewController.h"
#import "ServerCommunicator.h"
#import "CoreData+MagicalRecord.h"
#import "CommonData.h"

#define INFO_ITEM_COUNT 6;
#define IS_IPHONE_LOWERINCHE [[UIScreen mainScreen] bounds].size.height == 480


@interface PassengerEditViewController ()
{
    UIView *darkUILayer;
    UIView *pickerContainerView;
    UIDatePicker *datePicker;
    
    TickectInfoPicker *genderPicker;
    TickectInfoPicker *passportTypePicker;
    
    BOOL isAddingNewItem;
}
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
    
    [self initPassenger];
    [self.passengerInfoTableView setScrollEnabled:NO];
    [self setExtraCellLineHidden:self.passengerInfoTableView];
    
    [self initDarkUILayer];
    
    
    // 添加 取消／完成按钮
    UIBarButtonItem *cancel=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonFunction:)];
    
    UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithTitle:self.navigationBarDoneItemString style:UIBarButtonSystemItemDone target:self action:@selector(doneButtonFunction:)];
    
    
    self.navigationItem.leftBarButtonItem=cancel;
    self.navigationItem.rightBarButtonItem=done;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initPassenger
{
    if(self.passengerInfo==nil)
    {
        self.passengerInfo = [Passenger MR_createEntity];
        self.passengerInfo.passengerName = nil;
        self.passengerInfo.gender = nil;
        self.passengerInfo.birthDay = nil;
        self.passengerInfo.passportType = nil;
        self.passengerInfo.passportNumber = nil;
        self.passengerInfo.contactTelephone = nil;
        
        [self.passengerInfo savePassenger];
        
        isAddingNewItem = YES;
    }
    else
    {
        //保存被修改乘客的原有信息
        self.oldPassengerInfo = [Passenger MR_createEntity];
        self.oldPassengerInfo.passengerName = [NSString stringWithString:self.passengerInfo.passengerName];
        self.oldPassengerInfo.gender = [NSNumber numberWithInt: [self.passengerInfo.gender integerValue]];
        self.oldPassengerInfo.birthDay = self.passengerInfo.birthDay;
        self.oldPassengerInfo.passportType = [NSNumber numberWithInt: [self.passengerInfo.passportType integerValue]];
        self.oldPassengerInfo.passportNumber = [NSString stringWithString:self.passengerInfo.passportNumber];
        self.oldPassengerInfo.contactTelephone = [NSString stringWithString:self.passengerInfo.contactTelephone];
        
        //[self.oldPassengerInfo savePassenger];
        
        isAddingNewItem = NO;
    }
}
- (void)initDarkUILayer
{
    darkUILayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    darkUILayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    darkUILayer.userInteractionEnabled = NO;
    [self.view addSubview:darkUILayer];
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
        if (self.passengerInfo.passengerName!=nil)
        {
            cell.inputInfoTextField.text=self.passengerInfo.passengerName;
            
        }
        cell.inputInfoTextField.returnKeyType = UIReturnKeyDone;
        cell.mainTableView = tableView;
        cell.cellIndex = 0;
        //cell.inputInfoTextField.delegate = self;
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
        
        if( self.passengerInfo.gender != nil) //[self.passengerInfo.gender isEqualToNumber: [NSNumber numberWithInt:2]]|| [self.passengerInfo.gender isEqualToNumber: [NSNumber numberWithInt:1]])
        {
            if ([self.passengerInfo.gender isEqualToNumber: [NSNumber numberWithInt:2]])
            {
                cell.labelButton.text=@"女";
            }
            else
            {
                cell.labelButton.text=@"男";
            }
            cell.labelButton.textColor=[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
        }
        else
        {
            cell.labelButton.text=@"性别";
        }
        
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
        
        if (self.passengerInfo.birthDay!=nil)
        {
            //格式化日期时间
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
            cell.labelButton.text=[dateformatter stringFromDate:self.passengerInfo.birthDay];
            
            
           cell.labelButton.textColor=[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
        }
        else
        {
            cell.labelButton.text=@"出生日期";
        }
        
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
        
        if(self.passengerInfo.passportType != nil) //[self.passengerInfo.passportType isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            //根据类型切换
            switch ([self.passengerInfo.passportType integerValue]) {
                case ID: cell.labelButton.text=@"身份证";
                    break;
                case Passport: cell.labelButton.text=@"护照";
                    break;
                case Military: cell.labelButton.text=@"军人证";
                    break;
                case HomeReturePermit: cell.labelButton.text=@"回乡证";
                    break;
                case TaiWaner: cell.labelButton.text=@"台胞证";
                    break;
                case HongKongAndMacaoPermit: cell.labelButton.text=@"港澳通行证";
                    break;
                case InternationalSeaman: cell.labelButton.text=@"国际海员证";
                    break;
                case GreenCard: cell.labelButton.text=@"外国人永久居留证";
                    break;
                case Booklet: cell.labelButton.text=@"户口簿";
                    break;
                case BirthCertificate: cell.labelButton.text=@"出生证明";
                    break;
                case Other: cell.labelButton.text=@"其他";
                    break;
                default:
                    break;
            }
            cell.labelButton.textColor=[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
        }
        else
        {
            cell.labelButton.text=@"证件类型";
        }
        
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
        
        if(self.passengerInfo.passportNumber!=nil)
        {
            cell.inputInfoTextField.text=self.passengerInfo.passportNumber;
        }
        
        cell.inputInfoTextField.placeholder=@"证件号";
        
        cell.inputInfoTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.inputInfoTextField.returnKeyType = UIReturnKeyDone;
        cell.mainTableView = tableView;
        cell.cellIndex = 4;
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
        
        if(self.passengerInfo.contactTelephone!=nil)
        {
            cell.inputInfoTextField.text=self.passengerInfo.contactTelephone;
        }
        
        cell.inputInfoTextField.placeholder=@"联系手机";
        
        cell.inputInfoTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.inputInfoTextField.returnKeyType = UIReturnKeyDone;
        cell.mainTableView = tableView;
        cell.cellIndex = 5;
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
        //去除 focus
        NSIndexPath *tempPath =  [NSIndexPath indexPathForRow:0 inSection:0];
        PassengerInfoTextFieldCell *cell = (PassengerInfoTextFieldCell*)[self.passengerInfoTableView cellForRowAtIndexPath:tempPath];
        [cell.inputInfoTextField setSelected:NO];
        
        tempPath =  [NSIndexPath indexPathForRow:4 inSection:0];
        cell = (PassengerInfoTextFieldCell*)[self.passengerInfoTableView cellForRowAtIndexPath:tempPath];
        [cell.inputInfoTextField setSelected:NO];
        tempPath =  [NSIndexPath indexPathForRow:5 inSection:0];
        cell = (PassengerInfoTextFieldCell*)[self.passengerInfoTableView cellForRowAtIndexPath:tempPath];
        [cell.inputInfoTextField setSelected:NO];
        
        
        //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
        if(IS_IPHONE_LOWERINCHE)
        {
            CGRect frame = self.passengerInfoTableView.frame;
            
            frame.size.height = 480;
            self.passengerInfoTableView.frame = frame;
            
            self.passengerInfoTableView.scrollEnabled = NO;
            //self.mainTableView.userInteractionEnabled = YES;
            
            
        }
        
        [self pickerCellTapped:indexPath.row];
    }
}

#pragma mark - table view cell button event
- (void) pickerCellTapped:(NSInteger) index
{
    NSLog(@"test");
    if (index==1)
    {
        if(genderPicker==nil)
        {
            genderPicker = [[TickectInfoPicker alloc] initWithFrame:CGRectMake(0, 568, 320, 215)];
            genderPicker.tag = 0;
            genderPicker.delegate = self;
            [genderPicker initPickerData];
            [genderPicker initPickerToolBarWithTitle:@"                    性别                  "];
            [genderPicker addTargetForCancelButton:self action:@selector(genderPickerCancelPressed:)];
            [genderPicker addTargetForDoneButton:self action:@selector(genderPickerDonePressed:)];
            [[self navigationController].view addSubview:genderPicker];
        }
        self.view.userInteractionEnabled = NO;
        [self navigationController].navigationBar.userInteractionEnabled = NO;
        
        [self pushViewAnimationWithView:genderPicker willHidden:NO];
        genderPicker.hidden = NO;
    }
    else if (index == 2)
    {
        if (pickerContainerView == nil) {
            pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 568, 320, 215)];
            pickerContainerView.backgroundColor=[UIColor whiteColor];
            
            //date picker
            datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, pickerContainerView.frame.size.width, pickerContainerView.frame.size.height-50)];
            datePicker.datePickerMode = UIDatePickerModeDate;
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *currentDate = [NSDate date];
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setYear:-90];
            NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
            [comps setYear:0];
            NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
            
            datePicker.minimumDate = minDate;
            datePicker.maximumDate = maxDate;
            
            [pickerContainerView addSubview:datePicker];
            [self init:pickerContainerView Picker:datePicker ToolBarWithTitle:@"                出生日期               "];
            
            datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            
            datePicker.tag=10;
            pickerContainerView.autoresizesSubviews = YES;
            pickerContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            
            [[self navigationController].view addSubview:pickerContainerView];
        }
        self.view.userInteractionEnabled = NO;
        [self navigationController].navigationBar.userInteractionEnabled = NO;
        
        [self  pushViewAnimationWithView:pickerContainerView willHidden:NO];
        pickerContainerView.hidden = NO;
    }
    else if (index==3)
    {
        //passportTypePicker
        if(passportTypePicker==nil)
        {
            passportTypePicker = [[TickectInfoPicker alloc] initWithFrame:CGRectMake(0, 568, 320, 215)];
            passportTypePicker.tag = 1;
            passportTypePicker.delegate = self;
            [passportTypePicker initPickerData];
            [passportTypePicker initPickerToolBarWithTitle:@"                证件类型               "];
            [passportTypePicker addTargetForCancelButton:self action:@selector(passportTypePickerCancelPressed:)];
            [passportTypePicker addTargetForDoneButton:self action:@selector(passportTypePickerDonePressed:)];
            [[self navigationController].view addSubview:passportTypePicker];
        }
        self.view.userInteractionEnabled = NO;
        [self navigationController].navigationBar.userInteractionEnabled = NO;
        
        [self pushViewAnimationWithView:passportTypePicker willHidden:NO];
        passportTypePicker.hidden = NO;
    }
}



#pragma mark - ticketInfoPickerDelegate
- (NSArray*)generatePickerDataWithView:(UIView *)view
{
    NSArray* pickerData;
    if (view.tag == 0)
    {
        pickerData = [[NSArray alloc] initWithObjects:@"男",@"女", nil];
    }
    else
    {
        pickerData = [[NSArray alloc] initWithObjects:@"身份证",@"护照",@"军人证",@"回乡证",@"台胞证",@"港澳通行证",@"国际海员证",@"外国人永久居留证",@"户口簿",@"出生证明",@"其它", nil];
    }
    return pickerData;
}

#pragma mark - ticket info picker button event

- (void)genderPickerCancelPressed:(id)sender
{
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    [self pushViewAnimationWithView:genderPicker willHidden:YES];
    self.view.userInteractionEnabled = YES;
}
- (void)passportTypePickerCancelPressed:(id)sender
{
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    [self pushViewAnimationWithView:passportTypePicker willHidden:YES];
    self.view.userInteractionEnabled = YES;
}


- (void)genderPickerDonePressed:(id)sender
{
    
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    
    //self.passengerInfo.birthDay= datePicker.date;
    NSInteger index= [genderPicker.picker selectedRowInComponent:0];
    
    if(index==0)
    {
        self.passengerInfo.gender=[NSNumber numberWithInteger:Male];
    }
    else
    {
        self.passengerInfo.gender=[NSNumber numberWithInteger:Female];
    }
    
    [self.passengerInfoTableView reloadData];
    [self pushViewAnimationWithView:genderPicker willHidden:YES];
    self.view.userInteractionEnabled = YES;
}

- (void)passportTypePickerDonePressed:(id)sender
{
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    
    //self.passengerInfo.birthDay= datePicker.date;
    NSInteger index= [passportTypePicker.picker selectedRowInComponent:0];
    
    switch (index) {
        case 0: self.passengerInfo.passportType=[NSNumber numberWithInteger:ID];
            break;
        case 1: self.passengerInfo.passportType=[NSNumber numberWithInteger:Passport];
            break;
        case 2: self.passengerInfo.passportType=[NSNumber numberWithInteger:Military];
            break;
        case 3: self.passengerInfo.passportType=[NSNumber numberWithInteger:HomeReturePermit];
            break;
        case 4: self.passengerInfo.passportType=[NSNumber numberWithInteger:TaiWaner];
            break;
        case 5: self.passengerInfo.passportType=[NSNumber numberWithInteger:HongKongAndMacaoPermit];
            break;
        case 6: self.passengerInfo.passportType=[NSNumber numberWithInteger:InternationalSeaman];
            break;
        case 7: self.passengerInfo.passportType=[NSNumber numberWithInteger:GreenCard];
            break;
        case 8: self.passengerInfo.passportType=[NSNumber numberWithInteger:Booklet];
            break;
        case 9: self.passengerInfo.passportType=[NSNumber numberWithInteger:BirthCertificate];
            break;
        case 10: self.passengerInfo.passportType=[NSNumber numberWithInteger:Other];
            break;
        default:
            break;
    }
    
    [self.passengerInfoTableView reloadData];
    [self pushViewAnimationWithView:passportTypePicker willHidden:YES];
     self.view.userInteractionEnabled = YES;
}

#pragma mark - navigation button event
-(void) cancelButtonFunction:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
    //get the last view controller, reload table view data
    PassengerListViewController *plVC= (PassengerListViewController *)[self.navigationController visibleViewController];
    [plVC initPassengerListData];
    [plVC.passengerListTableView reloadData];
}

- (void) doneButtonFunction:(id) sender
{
    [self setPassengerInfo:self.passengerInfo ByTableViewData:self.passengerInfoTableView];
    if ([self checkInfo:self.passengerInfo])
    {
        //update
        if(isAddingNewItem)
        {
            //添加本机数据以及数据库数据
            //
            //
            NSDictionary *returnDic = [[ServerCommunicator sharedCommunicator] addContacts:self.passengerInfo];
            NSInteger returnCode = [returnDic[SERVER_RETURN_CODE_KEY] integerValue];
            
            
            if(returnCode == USER_LOGIN_SUCCESS)
            {
                //
                //alert 添加成功
                //返回
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"添加失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            [self.passengerInfo savePassenger];
//            NSArray *test = [Passenger findAllPassengers];
        }
        else
        {
            //修改本机数据以及数据库数据
            //
            //
            NSDictionary *returnDic = [[ServerCommunicator sharedCommunicator]
                                       modifyContact:self.oldPassengerInfo
                                       toNewContact:self.passengerInfo];
            
            NSInteger returnCode = [returnDic[SERVER_RETURN_CODE_KEY] integerValue];
            
            
            if(returnCode == USER_LOGIN_SUCCESS)
            {
                //
                //alert 修改成功
                //返回
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            [self.passengerInfo savePassenger];
//            NSArray *test = [Passenger findAllPassengers];
//            
//            Passenger *temp = [test objectAtIndex:30];
        }
    }
    else
    {
        //
    }
}

- (void) setPassengerInfo:(Passenger*) passengerInfo ByTableViewData:(UITableView*)tableView
{
    //set passengerInfo
    NSIndexPath* path=[NSIndexPath indexPathForRow: 0 inSection:0];
    PassengerInfoTextFieldCell *cell = (PassengerInfoTextFieldCell*)[tableView cellForRowAtIndexPath:path];
    passengerInfo.passengerName = cell.inputInfoTextField.text;
    
    path=[NSIndexPath indexPathForRow: 4 inSection:0];
    cell= (PassengerInfoTextFieldCell*)[tableView cellForRowAtIndexPath:path];
    passengerInfo.passportNumber = cell.inputInfoTextField.text;
    
    path=[NSIndexPath indexPathForRow: 5 inSection:0];
    cell= (PassengerInfoTextFieldCell*)[tableView cellForRowAtIndexPath:path];
    passengerInfo.contactTelephone = cell.inputInfoTextField.text;
    
}

- (Boolean) checkInfo:(Passenger*) passenger
{
    //name
    if (![self checkString:passenger.passengerName WithName:@"姓名"]) {
        return NO;
    }
    //gender
    if (self.passengerInfo.gender==nil) {
        NSString* messageS=[@"性别" stringByAppendingString:@"不能为空"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"填写错误" message:messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
        //return NO;
    }
    //birthday
    if (self.passengerInfo.birthDay==nil) {
        NSString* messageS=[@"出生日期" stringByAppendingString:@"不能为空"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"填写错误" message:messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    //passport type
    if (self.passengerInfo.passportType==nil) {
        NSString* messageS=[@"证件类型" stringByAppendingString:@"不能为空"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"填写错误" message:messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    //passport num
    if (![self checkString:passenger.passportNumber WithName:@"证件号"]) {
        return NO;
    }
    //phone number
    if (![self isPureInt:passenger.contactTelephone WithName:@"手机号"]) {
        return NO;
    }
    
    
    else
    {
        return YES;
    }
}

- (Boolean)checkString:(NSString*)target WithName:(NSString*) name
{
    
    if (target==nil||target.length==0)
    {
        NSString* messageS=[name stringByAppendingString:@"不能为空"];
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"填写错误" message: messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if ([target rangeOfString:@" "].location!=NSNotFound)
    {
        NSString* messageS=[name stringByAppendingString:@"不能有空格"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"填写错误" message:messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string WithName:(NSString*) name
{
    if (string==nil||string.length==0||[string isEqualToString:@"联系手机"])
    {
        NSString* messageS=[name stringByAppendingString:@"不能为空"];
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"填写错误" message: messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    if (!([scan scanInt:&val] && [scan isAtEnd]))
    {
        NSString* messageS=[name stringByAppendingString:@"只能包含纯数字"];
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"填写错误" message: messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

#pragma mark - ui alert delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"test");
    if (self.isDirectlyBackToTicketInfo) {
        //直接返回到机票支付页面
        [self.navigationController popViewControllerAnimated:YES];
        PassengerListViewController *plVC = (PassengerListViewController*)[self.navigationController visibleViewController];
        [plVC initPassengerListData];
        [plVC.passengerListTableView reloadData];
        plVC.isComeFromTicketPay = YES;
        //[plVC popDirectlyToTicketInfo];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        //get the last view controller, reload table view data
//        TickectInfoViewController *tiVC= (TickectInfoViewController *)[self.navigationController visibleViewController];
//        
//        [tiVC.passengerList addObject:self.passengerInfo];
//        [tiVC.cellTitleArray insertObject:[NSString stringWithFormat:@"  %@",self.passengerInfo.passengerName] atIndex:1];
//        tiVC.infoVessel.scrollEnabled = YES;
//        [tiVC.infoVessel reloadData];
    }
    else
    {
        //返回乘客人列表
        [self cancelButtonFunction:self];
    }
    
}

#pragma mark - utility functions
- (void)pushViewAnimationWithView:(UIView*)view willHidden:(BOOL)hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        if (hidden)
        {
            if (IS_IPHONE_LOWERINCHE) {
                view.frame = CGRectMake(0, 480, 320, 215);
            }
            else view.frame = CGRectMake(0, 568, 320, 215);

            //view.frame = CGRectMake(0, DEVICE_HEIGHT, 320, 215);
            darkUILayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        }
        else
        {
            [view setHidden:hidden];
            if (IS_IPHONE_LOWERINCHE) {
                view.frame = CGRectMake(0, 480 - 215, 320, 215);
            }
            else view.frame = CGRectMake(0, 568 - 215, 320, 215);
            //view.frame = CGRectMake(0, DEVICE_HEIGHT - 215, 320, 215);
            darkUILayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        }
    } completion:^(BOOL finished){
        [view setHidden:hidden];
    }];
}

#pragma mark - date picker bar
- (void)init:(UIView*) view Picker:(UIDatePicker*) picker ToolBarWithTitle:(NSString*)title
{
    //picker = title;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, view.frame.size.width, 50)];
    toolbar.barTintColor = [UIColor colorWithRed:0.05 green:0.64 blue:0.88 alpha:1.0];
    toolbar.tintColor = [UIColor whiteColor];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"确定" style: UIBarButtonItemStyleBordered target: self action: @selector(datePickerDonePressed:)];
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithTitle: title style: UIBarButtonItemStyleBordered target: self action: nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"取消" style: UIBarButtonItemStyleBordered target: self action: @selector(datePickerCancelPressed:)];
    toolbar.items = [NSArray arrayWithObjects:cancelButton,flexibleSpace, doneButton, nil];
    
    [view addSubview: toolbar];
}

- (void)datePickerCancelPressed:(id)sender
{
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    [self pushViewAnimationWithView:pickerContainerView willHidden:YES];
    self.view.userInteractionEnabled = YES;
}

- (void)datePickerDonePressed:(id)sender
{
    
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    
    self.passengerInfo.birthDay= datePicker.date;
    [self.passengerInfoTableView reloadData];
    
    [self pushViewAnimationWithView:pickerContainerView willHidden:YES];
    self.view.userInteractionEnabled = YES;
}


#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
