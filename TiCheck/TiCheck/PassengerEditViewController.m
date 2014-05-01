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
#import "EnumCollection.h"


#define INFO_ITEM_COUNT 6;

@interface PassengerEditViewController ()
{
    UIView *darkUILayer;
    UIView *pickerContainerView;
    UIDatePicker *datePicker;
    
    TickectInfoPicker *genderPicker;
    TickectInfoPicker *passportTypePicker;
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
        self.passengerInfo=[[Passenger alloc] init];
        self.passengerInfo.passengerName=nil;
        self.passengerInfo.gender=0;
        self.passengerInfo.birthDay=nil;
        self.passengerInfo.passportType=0;
        self.passengerInfo.passportNumber=nil;
        self.passengerInfo.contactTelephone=nil;
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
        
        if(self.passengerInfo.gender== Female ||self.passengerInfo.gender==Male)
        {
            if (self.passengerInfo.gender==Female)
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
        
        if(self.passengerInfo.passportType!= 0)
        {
            //根据类型切换
            switch (self.passengerInfo.passportType) {
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
        
        if(self.passengerInfo.contactTelephone!=nil)
        {
            cell.inputInfoTextField.text=self.passengerInfo.contactTelephone;
        }
        
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
            [genderPicker initPickerToolBarWithTitle:@"                  性别                  "];
            [genderPicker addTargetForCancelButton:self action:@selector(genderPickerCancelPressed:)];
            [genderPicker addTargetForDoneButton:self action:@selector(genderPickerDonePressed:)];
            [[self navigationController].view addSubview:genderPicker];
        }
        self.view.userInteractionEnabled = NO;
        [self navigationController].navigationBar.userInteractionEnabled = NO;
        
        [self pushViewAnimationWithView:genderPicker willHidden:NO];
        genderPicker.hidden = NO;
    }
    else if (index==2)
    {
        if (pickerContainerView==nil) {
            pickerContainerView= [[UIView alloc] initWithFrame:CGRectMake(0, 568, 320, 215)];
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
            [self init:pickerContainerView Picker:datePicker ToolBarWithTitle:@"                出生日期              "];
            
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
            [passportTypePicker initPickerToolBarWithTitle:@"               证件类型               "];
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
        self.passengerInfo.gender=Male;
    }
    else
    {
        self.passengerInfo.gender=Female;
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
        case 0: self.passengerInfo.passportType=ID;
            break;
        case 1: self.passengerInfo.passportType=Passport;
            break;
        case 2: self.passengerInfo.passportType=Military;
            break;
        case 3: self.passengerInfo.passportType=HomeReturePermit;
            break;
        case 4: self.passengerInfo.passportType=TaiWaner;
            break;
        case 5: self.passengerInfo.passportType=HongKongAndMacaoPermit;
            break;
        case 6: self.passengerInfo.passportType=InternationalSeaman;
            break;
        case 7: self.passengerInfo.passportType=GreenCard;
            break;
        case 8: self.passengerInfo.passportType=Booklet;
            break;
        case 9: self.passengerInfo.passportType=BirthCertificate;
            break;
        case 10: self.passengerInfo.passportType=Other;
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
}

- (void) doneButtonFunction:(id) sender
{
    [self setPassengerInfo:self.passengerInfo ByTableViewData:self.passengerInfoTableView];
    if ([self checkInfo:self.passengerInfo])
    {
        //修改
        //alert 修改成功
        //返回
        
        NSLog(@"confirm,Pay");
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
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
    PassengerInfoTextFieldCell *cell= (PassengerInfoTextFieldCell*)[tableView cellForRowAtIndexPath:path];
    passengerInfo.passengerName= cell.inputInfoTextField.text;
    
    path=[NSIndexPath indexPathForRow: 4 inSection:0];
    cell= (PassengerInfoTextFieldCell*)[tableView cellForRowAtIndexPath:path];
    passengerInfo.passportNumber= cell.inputInfoTextField.text;
    
    path=[NSIndexPath indexPathForRow: 5 inSection:0];
    cell= (PassengerInfoTextFieldCell*)[tableView cellForRowAtIndexPath:path];
    passengerInfo.contactTelephone= cell.inputInfoTextField.text;
    
}

- (Boolean) checkInfo:(Passenger*) passenger
{
    return YES;
}

#pragma mark - ui alert delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"test");
    [self cancelButtonFunction:self];

}

#pragma mark - utility functions
- (void)pushViewAnimationWithView:(UIView*)view willHidden:(BOOL)hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        if (hidden)
        {
            view.frame = CGRectMake(0, 568, 320, 215);
            darkUILayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        }
        else
        {
            [view setHidden:hidden];
            view.frame = CGRectMake(0, 568 - 215, 320, 215);
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
