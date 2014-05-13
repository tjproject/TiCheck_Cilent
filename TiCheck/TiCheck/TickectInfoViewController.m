//
//  TickectInfoViewController.m
//  TiCheck
//
//  Created by 大畅 on 14-4-11.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "TickectInfoViewController.h"
#import "PayProcessViewController.h"
#import "PassengerListViewController.h"
#import "PersonalCenterViewController.h"

#import "NSDate-Utilities.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"

#import "APIResourceHelper.h"
#import "CraftType.h"

#import "Flight.h"

#define CELL_BUTTON_RECT CGRectMake(285, 13, 23, 22)
#define PASSENGER_CELL_START_COUNT 6000

@interface TickectInfoViewController ()
//{
//    NSMutableArray *cellTitleArr;
//}
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
    [self initNavBar];
    [self initLabel];
    [self initImage];
    [self initButton];
    [self initInfoVessel];
    [self initDarkUILayer];
    [self initTextInputFields];
    [self initPassengerList];
//    [NSTimer scheduledTimerWithTimeInterval:0.033f target:self
//                                   selector:@selector(mainLoop:) userInfo:nil repeats:YES];
}

- (void)initNavBar
{
    UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 22)];
    [tempBtn setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:tempBtn];
    self.navigationItem.rightBarButtonItem = closeButton;
}

- (void)initLabel
{
    _TIVC_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 68, 160, 30)];
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE"];
    _TIVC_timeLabel.text = [NSString stringWithFormat:@"%d年%d月%d日 %@",_departureDate.year,_departureDate.month,_departureDate.day,[weekday stringFromDate:_departureDate]];
    _TIVC_fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(192, 68, 60, 30)];
    _TIVC_fromLabel.text = _selectFlight.departCityName;
    _TIVC_toLabel = [[UILabel alloc] initWithFrame:CGRectMake(227, 68, 68, 30)];
    _TIVC_toLabel.text = [NSString stringWithFormat:@"到 %@",_selectFlight.arriveCityName];
    _TIVC_flightLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 100, 280, 30)];
    CraftType *ct = [[APIResourceHelper sharedResourceHelper] findCraftTypeViaCT:_selectFlight.craftType];
    if(_selectFlight.airlineName == nil) _selectFlight.airlineName = @"东方航空";
    _TIVC_flightLabel.text = [NSString stringWithFormat:@"%@%@ %@ %@",_selectFlight.airlineShortName,_selectFlight.flightNumber,[ct craftKindShowingOnResultInTicketInfo],[NSString classGradeToChinese:_selectFlight.classGrade]];
    
    _TIVC_flightTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 170, 100, 50)];
    _TIVC_flightTimeLabel.text = [NSString showingStringFormatWithString:_selectFlight.takeOffTime];
    _TIVC_landTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(223, 170, 100, 50)];
    _TIVC_landTimeLabel.text = [NSString showingStringFormatWithString:_selectFlight.arrivalTime];
    
    _TIVC_fromAirportLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 180, 50, 25)];
    _TIVC_fromAirportLabel.text = [NSString stringWithFormat:@"%@%d",_selectFlight.departPortShortName,_selectFlight.departPortBuildingID];
    _TIVC_toAirportLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 180, 50, 25)];
    _TIVC_toAirportLabel.text = [NSString stringWithFormat:@"%@%d",_selectFlight.arrivePortShortName,_selectFlight.arrivePortBuildingID];
    NSLog(@"%@",_selectFlight.arrivePortBuildingName);
    
    _TIVC_ticketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 232, 50, 25)];
    _TIVC_ticketPriceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)_selectFlight.price];
    _TIVC_constructionPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 235, 50, 25)];
    _TIVC_constructionPriceLabel.text = @"¥50";
    _TIVC_fuelPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 235, 50, 25)];
    _TIVC_fuelPriceLabel.text = [NSString stringWithFormat:@"¥%.0f",_selectFlight.adultOilFee];
    _TIVC_discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 232, 50, 25)];
    _TIVC_discountLabel.text = [NSString stringWithFormat:@"%.1f折", _selectFlight.rate * 10];
    
    _TIVC_timeLabel.font = _TIVC_fromLabel.font = _TIVC_toLabel.font = _TIVC_flightLabel.font = [UIFont fontWithName:@"Arial" size:15.f];
    _TIVC_fromAirportLabel.font = _TIVC_toAirportLabel.font = _TIVC_discountLabel.font = [UIFont fontWithName:@"Arial" size:13.f];
    _TIVC_fromAirportLabel.textColor = _TIVC_toAirportLabel.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.0];
    _TIVC_flightTimeLabel.font = _TIVC_landTimeLabel.font = [UIFont fontWithName:@"Roboto-BoldCondensed" size:35.f];
    _TIVC_ticketPriceLabel.font = _selectFlight.price < 1000 ? [UIFont fontWithName:@"Roboto-Condensed" size:24.f] : [UIFont fontWithName:@"Roboto-Condensed" size:18.f];
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

- (void)initTextInputFields
{
    nameInputField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 320, 48)];
    phoneInputField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 320, 48)];
    addressInputField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 320, 48)];
    submitTitleInputField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, 320, 48)];
    nameInputField.tag = 3;
    phoneInputField.tag = 4;
    addressInputField.tag = 5;
    submitTitleInputField.tag = 6;
    nameInputField.delegate = phoneInputField.delegate = addressInputField.delegate = submitTitleInputField.delegate = self;
    nameInputField.returnKeyType = phoneInputField.returnKeyType = addressInputField.returnKeyType = submitTitleInputField.returnKeyType = UIReturnKeyDone;
    nameInputField.tintColor = phoneInputField.tintColor = addressInputField.tintColor = submitTitleInputField.tintColor = [UIColor colorWithRed:0.05 green:0.64 blue:0.87 alpha:1.0];
    inputFieldArray = [[NSArray alloc] initWithObjects:nameInputField,phoneInputField,addressInputField,submitTitleInputField, nil];
}

- (void)initImage
{
    _TIVC_flightImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 30, 30)];
    _TIVC_flightImage.image = [UIImage imageNamed:self.selectFlight.airlineDibitCode];
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

- (void)initDarkUILayer
{
    darkUILayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    darkUILayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    darkUILayer.userInteractionEnabled = NO;
    [self.view addSubview:darkUILayer];
}

- (void)initPassengerList
{
    _passengerList = [[NSMutableArray alloc] init];
}

#pragma mark - buttons in cell
- (void)initInfoVessel
{
    _infoVessel = [[UITableView alloc] initWithFrame:CGRectMake(0, 282, 320, 536-282-15
                                                                )];
    _infoVessel.dataSource = self;
    _infoVessel.delegate = self;
    [_infoVessel setSeparatorInset:UIEdgeInsetsZero];
    _infoVessel.scrollEnabled = NO;
    _infoVessel.showsVerticalScrollIndicator = NO;
    _infoVessel.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [self.view addSubview:_infoVessel];
    _cellTitleArray = [NSMutableArray arrayWithObjects:@"登机人",@"航空意外险",@"报销凭证", nil];
    assranceInfo = @"¥30x1份";
    submitInfo = @"不需要报销凭证";
    _passengerList = [[NSMutableArray alloc] init];
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return _cellTitleArray.count;}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1.0];
    if (indexPath.row == 0)
    {
        UIImageView *addPassengerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passengerButton"]];
        cell.accessoryView = addPassengerView;
    }
    else if(indexPath.row <= _passengerList.count)
    {
        if(_passengerList.count > 0)
        {
            cell.detailTextLabel.text = @"";
            cell.textLabel.textColor = [UIColor colorWithRed:0.05 green:0.64 blue:0.88 alpha:1.0];
            [self initDeletePassengerButtonInCell:cell withIndexPath:indexPath];
        }
    }
    else if(indexPath.row == _passengerList.count + 1)
    {
        cell.accessoryView = nil;
        cell.detailTextLabel.text = assranceInfo;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0 alpha:1.0];
    }
    else if(indexPath.row == _passengerList.count + 2)
    {
        cell.accessoryView = nil;
        cell.detailTextLabel.text = submitInfo;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.05 green:0.64 blue:0.88 alpha:1.0];
    }
    else if(indexPath.row == _passengerList.count + 3 || indexPath.row == _passengerList.count + 4 || indexPath.row == _passengerList.count + 5 || indexPath.row == _passengerList.count + 6)
    {
        cell.accessoryView = nil;
        cell.detailTextLabel.text = @"";
        [self initInputFieldInView:cell With:[inputFieldArray objectAtIndex:[indexPath row] - _passengerList.count - 3]];
    }
    else
    {
    }
    cell.textLabel.text = [_cellTitleArray objectAtIndex:[indexPath row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 48;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        PassengerListViewController *peVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PassengerListViewController"];
        peVC.isComeFromTicketPay=YES;
        [self.navigationController pushViewController:peVC animated:YES];
    }
    else if(indexPath.row == _passengerList.count + 1)
    {
        self.view.userInteractionEnabled = NO;
        [self navigationController].navigationBar.userInteractionEnabled = NO;
        _TIVC_assurancePicker = [[TickectInfoPicker alloc] initWithFrame:CGRectMake(0, 568, 320, 215)];
        _TIVC_assurancePicker.tag = 0;
        _TIVC_assurancePicker.delegate = self;
        [_TIVC_assurancePicker initPickerData];
        [_TIVC_assurancePicker addTargetForCancelButton:self action:@selector(assuranceCancelPressed)];
        [_TIVC_assurancePicker addTargetForDoneButton:self action:@selector(assuranceDonePressed)];
        [[self navigationController].view addSubview:_TIVC_assurancePicker];
        [self pushViewAnimationWithView:_TIVC_assurancePicker willHidden:NO];
        _TIVC_assurancePicker.hidden = NO;
    }
    else if(indexPath.row == _passengerList.count + 2)
    {
        self.view.userInteractionEnabled = NO;
        [self navigationController].navigationBar.userInteractionEnabled = NO;
        _TIVC_submitPicker = [[TickectInfoPicker alloc] initWithFrame:CGRectMake(0, 568, 320, 215)];
        _TIVC_submitPicker.tag = 1;
        _TIVC_submitPicker.delegate = self;
        [_TIVC_submitPicker initPickerData];
        [_TIVC_submitPicker initPickerToolBarWithTitle:@"         是否需要报销凭证       "];
        [_TIVC_submitPicker addTargetForCancelButton:self action:@selector(submitCancelPressed)];
        [_TIVC_submitPicker addTargetForDoneButton:self action:@selector(submitDonePressed)];
        [[self navigationController].view addSubview:_TIVC_submitPicker];
        [self pushViewAnimationWithView:_TIVC_submitPicker willHidden:NO];
        _TIVC_submitPicker.hidden = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1f animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished){
    }];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4f animations:^{
        self.view.frame = CGRectMake(0, -172, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished){
    }];
    return YES;
}

#pragma mark - ticketInfoPickerDelegate
- (NSArray*)generatePickerDataWithView:(UIView *)view
{
    if (view.tag == 0)
    {
        pickerData = [[NSArray alloc] initWithObjects:@"¥30x1份",@"不购买保险", nil];
    }
    else
    {
        pickerData = [[NSArray alloc] initWithObjects:@"不需要报销凭证",@"邮寄报销凭证", nil];
    }
    return pickerData;
}

#pragma mark - target selector
- (void)closeButtonPressed:(id)sender
{
    PersonalCenterViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"];
    UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:pVC];
    viewController.navigationBar.barTintColor = [UIColor colorWithRed:0.05 green:0.64 blue:0.87 alpha:1.0];
    viewController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self presentModalViewController:viewController animated:YES];
}

- (void)bookButtonPressed:(id)sender
{
    //add booking logic
    if([sender isSelected])
    {
        [sender setImage:[UIImage imageNamed:@"bookButton"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"bookButtonActive"] forState:UIControlStateNormal];
        [sender setSelected:YES];
    }
}

- (void)confirmPressed:(id)sender
{
    if (_passengerList.count > 0)
    {
        PayProcessViewController *ppVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PayProcessViewController"];
        //传递值
        ppVC.selectFlight = _selectFlight;
        ppVC.departureDate = _departureDate;
        ppVC.passengerList = _passengerList;
        //
        //...
        //
        [self.navigationController pushViewController:ppVC animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"乘客不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)assuranceCancelPressed
{
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    [self pushViewAnimationWithView:_TIVC_assurancePicker willHidden:YES];
    self.view.userInteractionEnabled = YES;
}

- (void)assuranceDonePressed
{
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    assranceInfo = [_TIVC_assurancePicker.pickerData objectAtIndex:[_TIVC_assurancePicker.picker selectedRowInComponent:0]];
    [_infoVessel reloadData];
    [self pushViewAnimationWithView:_TIVC_assurancePicker willHidden:YES];
    self.view.userInteractionEnabled = YES;
}

- (void)submitCancelPressed
{
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    [self pushViewAnimationWithView:_TIVC_submitPicker willHidden:YES];
    self.view.userInteractionEnabled = YES;
}

- (void)submitDonePressed
{
    [self navigationController].navigationBar.userInteractionEnabled = YES;
    submitInfo = [_TIVC_submitPicker.pickerData objectAtIndex:[_TIVC_submitPicker.picker selectedRowInComponent:0]];
    if([submitInfo isEqualToString:@"邮寄报销凭证"])
    {
        if ([[_cellTitleArray objectAtIndex:[_cellTitleArray count] - 1] isEqualToString:@"报销凭证"])
        {
            [_cellTitleArray addObject:@"收件人姓名"];
            [_cellTitleArray addObject:@"联系电话"];
            [_cellTitleArray addObject:@"收件地址"];
            [_cellTitleArray addObject:@"发票抬头"];
            _infoVessel.scrollEnabled = YES;
        }
    }
    else if([[_cellTitleArray objectAtIndex:[_cellTitleArray count] - 1] isEqualToString:@"发票抬头"])
    {
        [_cellTitleArray removeObject:@"收件人姓名"];
        [_cellTitleArray removeObject:@"联系电话"];
        [_cellTitleArray removeObject:@"收件地址"];
        [_cellTitleArray removeObject:@"发票抬头"];
        _infoVessel.scrollEnabled = NO;
    }
    [_infoVessel reloadData];
    [self pushViewAnimationWithView:_TIVC_submitPicker willHidden:YES];
    self.view.userInteractionEnabled = YES;
}

- (void)deletePassengerButtonPressed:(id)sender
{
    UIButton *senderButton = (UIButton*)sender;
    [_cellTitleArray removeObjectAtIndex:senderButton.tag - PASSENGER_CELL_START_COUNT];
    [_passengerList removeObjectAtIndex:senderButton.tag - PASSENGER_CELL_START_COUNT - 1];
    [_infoVessel deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:senderButton.tag - PASSENGER_CELL_START_COUNT inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
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

- (void)initInputFieldInView:(UIView*)view With:(UITextField*)textField;
{
    [view addSubview:textField];
}

- (void)initDeletePassengerButtonInCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    UIButton *tempDeletePassengerButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 24, 24)];
    tempDeletePassengerButton.tag = PASSENGER_CELL_START_COUNT + indexPath.row;
    [tempDeletePassengerButton setImage:[UIImage imageNamed:@"deletePassengerButton"] forState:UIControlStateNormal];
    [tempDeletePassengerButton addTarget:self action:@selector(deletePassengerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = tempDeletePassengerButton;
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
