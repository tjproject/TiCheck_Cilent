//
//  SubscriptionViewController.m
//  TiCheck
//
//  Created by Boyi on 4/24/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "CommonData.h"
#import "Subscription.h"
#import "ServerCommunicator.h"

typedef NS_ENUM(NSUInteger, SelectedDateType) {
    BeginDate,
    EndDate
};

@interface SubscriptionViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DateSelectViewControllerDelegate, CitySelectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *subscribeOptionTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *optionSelectToolBar;
@property (weak, nonatomic) IBOutlet UIPickerView *optionSelectPickerView;

@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (weak, nonatomic) FromToTableViewCell *fromToCell;
@property (weak, nonatomic) DateIntervalTableViewCell *takeOffDateIntervalCell;
@property (weak, nonatomic) DateIntervalTableViewCell *returnDateIntervalCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *airlineCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *seatCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *departAirportCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *arriveAirportCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *takeOffTimeCell;

@property (nonatomic, strong) NSArray *pickerData;

@end

@implementation SubscriptionViewController
{
    BOOL isReturn; // 是否返程
    BOOL isShowMore; // 是否显示更多
    
    SelectedDateType selectedDateType; // 选择是开始还是结束日期
    SelectingOption selectingOption; // 正在进行的选项
}

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
    isReturn = NO;
    isShowMore = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)pickerData
{
    if (_pickerData == nil) {
        _pickerData = [NSArray array];
    }
    
    return _pickerData;
}

#pragma mark - Events

- (IBAction)confirmSubscription:(id)sender
{
    Subscription *takeOffSubscription = [[Subscription alloc] initWithDepartCity:self.fromToCell.fromCityLabel.text arriveCity:self.fromToCell.toCityLabel.text startDate:self.takeOffDateIntervalCell.beginDate.text endDate:self.takeOffDateIntervalCell.endDate.text];
    if (isShowMore) {
        NSArray *departTime = [self.takeOffTimeCell.generalValue.titleLabel.text componentsSeparatedByString:@" ~ "];
        [takeOffSubscription modifyMoreOptionWithEarliestDepartTime:departTime[0] LatestDepartTime:departTime[1] airlineShortName:self.airlineCell.generalValue.titleLabel.text arriveAirportName:self.arriveAirportCell.generalValue.titleLabel.text departAirportName:self.departAirportCell.generalValue.titleLabel.text];
    }
    NSDictionary *tempD = [[ServerCommunicator sharedCommunicator] createSubscriptionWithSubscription:takeOffSubscription];
    NSLog(@"%@",tempD);
    //[[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)moreOptionClicked:(id)sender
{
    isShowMore = YES;
    
    NSInteger moreOptionsBeginCounter = 3;
    if (isReturn) moreOptionsBeginCounter++;
    
    NSMutableArray *moreOptionIndexArray = [NSMutableArray array];
    for (NSInteger i = 0; i < MORE_OPTION_COUNT; ++i) {
        NSIndexPath *toAddOption = [NSIndexPath indexPathForRow:moreOptionsBeginCounter + i inSection:0];
        [moreOptionIndexArray addObject:toAddOption];
    }
    
    NSIndexPath *moreButton = [NSIndexPath indexPathForRow:moreOptionsBeginCounter inSection:0];
    
    [self.subscribeOptionTableView beginUpdates];
    [self.subscribeOptionTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:moreButton] withRowAnimation:UITableViewRowAnimationTop];
    [self.subscribeOptionTableView insertRowsAtIndexPaths:moreOptionIndexArray withRowAnimation:UITableViewRowAnimationTop];
    [self.subscribeOptionTableView endUpdates];
    
    if (isReturn) {
        [UIView animateWithDuration:0.3f animations:^{
            self.buttonView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * MORE_OPTION_COUNT * 2);
            [self.buttonView layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.buttonView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * (MORE_OPTION_COUNT - 1) * 2);
            [self.buttonView layoutIfNeeded];
        }];
    }
}

- (IBAction)returnOptionChanged:(id)sender
{
    isReturn = !isReturn;
    
    if (CGRectEqualToRect(self.optionSelectPickerView.frame, SHOW_PICKER_VIEW_FRAME)) {
        [self hideToolBarAndPickerWithAnimation:YES];
    }
    
    NSIndexPath *returnIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    if (isReturn) {
        [self.subscribeOptionTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:returnIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (isShowMore) {
            [UIView animateWithDuration:0.3f animations:^{
                self.buttonView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * MORE_OPTION_COUNT * 2);
                [self.buttonView layoutIfNeeded];
            }];
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                self.buttonView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * 2);
                [self.buttonView layoutIfNeeded];
            }];
        }
    } else {
        [self.subscribeOptionTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:returnIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (isShowMore) {
            [UIView animateWithDuration:0.3f animations:^{
                self.buttonView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * (MORE_OPTION_COUNT - 1) * 2);
                [self.buttonView layoutIfNeeded];
            }];
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                self.buttonView.transform = CGAffineTransformMakeTranslation(0, 0);
                [self.buttonView layoutIfNeeded];
            }];
        }
    }
}

- (IBAction)closePicker:(id)sender
{
    [self hideToolBarAndPickerWithAnimation:YES];
}

- (IBAction)confirmPicker:(id)sender
{
    NSInteger selectRow = [self.optionSelectPickerView selectedRowInComponent:0];
    NSString *selectValue = [self.pickerData objectAtIndex:selectRow];
    
    switch (selectingOption) {
        case SelectingAirline:
            [self.airlineCell.generalValue setTitle:selectValue forState:UIControlStateNormal];
            break;
        case SelectingSeat:
            [self.seatCell.generalValue setTitle:selectValue forState:UIControlStateNormal];
            break;
        case SelectingDepartAirport:
            [self.departAirportCell.generalValue setTitle:selectValue forState:UIControlStateNormal];
            break;
        case SelectingArriveAirport:
            [self.arriveAirportCell.generalValue setTitle:selectValue forState:UIControlStateNormal];
            break;
        case SelectingTakeOffTime:
            [self.takeOffTimeCell.generalValue setTitle:selectValue forState:UIControlStateNormal];
            break;
    }
    
    [self hideToolBarAndPickerWithAnimation:YES];
}

#pragma mark - Gesture Selectors

- (void)optionLabelTapped:(UITapGestureRecognizer *)sender
{
    UILabel *label = (UILabel *)sender.view;
    
    if (label == self.fromToCell.fromCityLabel) {
        CitySelectViewController *citiesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CitySelectViewConrtoller"];
        citiesViewController.delegate = self;
        citiesViewController.selectCityType = From_City;
        
        [self presentViewController:citiesViewController animated:YES completion:nil];
    } else if (label == self.fromToCell.toCityLabel) {
        CitySelectViewController *citiesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CitySelectViewConrtoller"];
        citiesViewController.delegate = self;
        citiesViewController.selectCityType = To_City;
        
        [self presentViewController:citiesViewController animated:YES completion:nil];
    } else if (label == self.takeOffDateIntervalCell.beginDate) {
        DateSelectViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelectViewController"];
        
        dateViewController.selectedDate = [NSString dateFormatWithString:self.takeOffDateIntervalCell.beginDate.text];
        dateViewController.delegate = self;
        dateViewController.routeType = Take_Off;
        dateViewController.beginDate = [NSDate date];
        dateViewController.isTodayButtonHidden = NO;
        selectedDateType = BeginDate;
        
        [self presentViewController:dateViewController animated:YES completion:nil];
    } else if (label == self.takeOffDateIntervalCell.endDate) {
        DateSelectViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelectViewController"];
        
        dateViewController.selectedDate = [NSString dateFormatWithString:self.takeOffDateIntervalCell.endDate.text];
        dateViewController.delegate = self;
        dateViewController.routeType = Take_Off;
        dateViewController.beginDate = [NSString dateFormatWithString:self.takeOffDateIntervalCell.beginDate.text];
        dateViewController.isTodayButtonHidden = YES;
        selectedDateType = EndDate;
        
        [self presentViewController:dateViewController animated:YES completion:nil];
    } else if (label == self.returnDateIntervalCell.beginDate) {
        DateSelectViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelectViewController"];
        
        dateViewController.selectedDate = [NSString dateFormatWithString:self.returnDateIntervalCell.beginDate.text];
        dateViewController.delegate = self;
        dateViewController.routeType = Return;
        // 暂时把返回时间段的开始时间设定为大于出发时间段的结束时间，之后可调整
        dateViewController.beginDate = [NSString dateFormatWithString:self.takeOffDateIntervalCell.endDate.text];
        dateViewController.isTodayButtonHidden = YES;
        selectedDateType = BeginDate;
        
        [self presentViewController:dateViewController animated:YES completion:nil];
    } else if (label == self.returnDateIntervalCell.endDate) {
        DateSelectViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelectViewController"];
        
        dateViewController.selectedDate = [NSString dateFormatWithString:self.returnDateIntervalCell.endDate.text];
        dateViewController.delegate = self;
        dateViewController.routeType = Return;
        dateViewController.beginDate = [NSString dateFormatWithString:self.returnDateIntervalCell.beginDate.text];
        dateViewController.isTodayButtonHidden = YES;
        selectedDateType = EndDate;
        
        [self presentViewController:dateViewController animated:YES completion:nil];
    }
}

#pragma mark - delegate

- (void)setFromCityLabel:(NSString *)fromCityString
{
    self.fromToCell.fromCityLabel.text = fromCityString;
}

- (void)setToCityLabel:(NSString *)toCityString
{
    self.fromToCell.toCityLabel.text = toCityString;
}

- (void)setTakeOffTimeLabel:(NSDate *)takeOffDate
{
    switch (selectedDateType) {
        case BeginDate:
            self.takeOffDateIntervalCell.beginDate.text = [NSString stringFormatWithDate:takeOffDate];
            // 若选择开始时间晚于结束时间，调整结束时间为开始时间
            if ([takeOffDate isLaterThanDate:[NSString dateFormatWithString:self.takeOffDateIntervalCell.endDate.text]]) {
                self.takeOffDateIntervalCell.endDate.text = [NSString stringFormatWithDate:takeOffDate];
                if ([[NSString dateFormatWithString:self.takeOffDateIntervalCell.endDate.text] isLaterThanDate:[NSString dateFormatWithString:self.returnDateIntervalCell.beginDate.text]]) {
                    self.returnDateIntervalCell.beginDate.text = self.takeOffDateIntervalCell.endDate.text;
                    if ([[NSString dateFormatWithString:self.returnDateIntervalCell.beginDate.text] isLaterThanDate:[NSString dateFormatWithString:self.returnDateIntervalCell.endDate.text]]) {
                        self.returnDateIntervalCell.endDate.text = self.returnDateIntervalCell.beginDate.text;
                    }
                }
            }
            break;
        case EndDate:
            self.takeOffDateIntervalCell.endDate.text = [NSString stringFormatWithDate:takeOffDate];
            if ([takeOffDate isLaterThanDate:[NSString dateFormatWithString:self.returnDateIntervalCell.beginDate.text]]) {
                self.returnDateIntervalCell.beginDate.text = self.takeOffDateIntervalCell.endDate.text;
                if ([[NSString dateFormatWithString:self.returnDateIntervalCell.beginDate.text] isLaterThanDate:[NSString dateFormatWithString:self.returnDateIntervalCell.endDate.text]]) {
                    self.returnDateIntervalCell.endDate.text = self.returnDateIntervalCell.beginDate.text;
                }
            }
    }
}

- (void)setReturnTimeLabel:(NSDate *)returnDate
{
    switch (selectedDateType) {
        case BeginDate:
            self.returnDateIntervalCell.beginDate.text = [NSString stringFormatWithDate:returnDate];
            // 若选择开始时间晚于结束时间，调整结束时间为开始时间
            if ([returnDate isLaterThanDate:[NSString dateFormatWithString:self.returnDateIntervalCell.endDate.text]]) {
                self.returnDateIntervalCell.endDate.text = [NSString stringFormatWithDate:returnDate];
            }
            break;
        case EndDate:
            self.returnDateIntervalCell.endDate.text = [NSString stringFormatWithDate:returnDate];
    }
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 4;
    
    if (isReturn) result++;
    if (isShowMore) result += MORE_OPTION_COUNT - 1;
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fromToCellIdentifier = @"FromToCell";
    static NSString *dateCellIdentifier = @"DateIntervalCell";
    static NSString *isReturnCellIdentifier = @"IsReturnCell";
    static NSString *showMoreCellIdentifier = @"ShowMoreCell";
    static NSString *generalOptionCellIdentifier = @"GeneralOptionCell";
    
    if (indexPath.row == 0) {
        // FromTo选项
        FromToTableViewCell *fromToCell = [tableView dequeueReusableCellWithIdentifier:fromToCellIdentifier];
        if (fromToCell == nil) {
            fromToCell = [[FromToTableViewCell alloc] init];
        }
        
        self.fromToCell = fromToCell;
        UITapGestureRecognizer *fromSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
        UITapGestureRecognizer *toSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
        [self.fromToCell.fromCityLabel addGestureRecognizer:fromSelectGesture];
        [self.fromToCell.toCityLabel addGestureRecognizer:toSelectGesture];
//        self.fromToCell.fromCityLabel.text = [SearchOption sharedSearchOption].departCityName;
//        self.fromToCell.toCityLabel.text = [SearchOption sharedSearchOption].arriveCityName;
        
        return fromToCell;
    } else if (indexPath.row == 1) {
        // TakeOffDate选项
        DateIntervalTableViewCell *takeOffDateIntervalCell = [tableView dequeueReusableCellWithIdentifier:dateCellIdentifier];
        if (takeOffDateIntervalCell == nil) {
            takeOffDateIntervalCell = [[DateIntervalTableViewCell alloc] init];
        }
        
        self.takeOffDateIntervalCell = takeOffDateIntervalCell;
        UITapGestureRecognizer *takeOffBeginDateSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
        UITapGestureRecognizer *takeOffEndDateSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
        [self.takeOffDateIntervalCell.beginDate addGestureRecognizer:takeOffBeginDateSelectGesture];
        [self.takeOffDateIntervalCell.endDate addGestureRecognizer:takeOffEndDateSelectGesture];
//        self.takeOffDateCell.dateLabel.text = [NSString stringFormatWithDate:[SearchOption sharedSearchOption].takeOffDate];
        
        return takeOffDateIntervalCell;
    } else {
        NSInteger isReturnIndexRow = 2;
        // 若为返程则第二行为返程时间
        if (isReturn) {
            isReturnIndexRow++;
            if (indexPath.row == 2) {
                DateIntervalTableViewCell *returnDateCell = [tableView dequeueReusableCellWithIdentifier:dateCellIdentifier];
                if (returnDateCell == nil) {
                    returnDateCell = [[DateIntervalTableViewCell alloc] init];
                }
                
                self.returnDateIntervalCell = returnDateCell;
                UITapGestureRecognizer *returnBeginDateSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
                UITapGestureRecognizer *returnEndDateSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
                [self.returnDateIntervalCell.beginDate addGestureRecognizer:returnBeginDateSelectGesture];
                [self.returnDateIntervalCell.endDate addGestureRecognizer:returnEndDateSelectGesture];
//                self.returnDateCell.dateLabel.text = [NSString stringFormatWithDate:[SearchOption sharedSearchOption].returnDate];
                
                // 显示返程时间时，若早于出发时间，调整至出发时间
                if ([[NSString dateFormatWithString:self.returnDateIntervalCell.beginDate.text] isEarlierThanDate:[NSString dateFormatWithString:self.takeOffDateIntervalCell.endDate.text]]) {
                    self.returnDateIntervalCell.beginDate.text = self.returnDateIntervalCell.endDate.text = self.takeOffDateIntervalCell.endDate.text;
                }
                
                return returnDateCell;
            }
        }
        // 是否返程Option
        if (indexPath.row == isReturnIndexRow) {
            UITableViewCell *isReturnCell = [tableView dequeueReusableCellWithIdentifier:isReturnCellIdentifier
                                                                            forIndexPath:indexPath];
            return isReturnCell;
        }
    }
    
    NSInteger moreOptionIndexRow = 3;
    if (isReturn) moreOptionIndexRow++;
    
    GeneralOptionTableViewCell *generalCell = [tableView dequeueReusableCellWithIdentifier:generalOptionCellIdentifier];
    if (generalCell == nil) {
        generalCell = [[GeneralOptionTableViewCell alloc] init];
    }
    
    if (!isShowMore) {
        // ShowMore的Button
        if (indexPath.row == moreOptionIndexRow) {
            UITableViewCell *showMoreCell = [tableView dequeueReusableCellWithIdentifier:showMoreCellIdentifier
                                                                            forIndexPath:indexPath];
            return showMoreCell;
        }
    } else {
        if (indexPath.row == moreOptionIndexRow) {
            // Airline选项
            generalCell.generalIcon.image = [UIImage imageNamed:@"Airline"];
            generalCell.generalLabel.text = @"航空公司";
            [generalCell.generalValue setTitle:@"不限" forState:UIControlStateNormal];
            [generalCell.generalValue setImage:[UIImage imageNamed:@"EA_Logo"] forState:UIControlStateNormal];
            self.airlineCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 1) {
            // 舱位选项
            generalCell.generalIcon.image = [UIImage imageNamed:@"Seat"];
            generalCell.generalLabel.text = @"舱位";
            generalCell.generalValue.titleLabel.text = @"不限";
            self.seatCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 2) {
            // 出发机场选择
            generalCell.generalIcon.image = [UIImage imageNamed:@"Airport"];
            generalCell.generalLabel.text = @"出发机场";
            generalCell.generalValue.titleLabel.text = @"不限";
            self.departAirportCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 3) {
            generalCell.generalIcon.image = [UIImage imageNamed:@"Airport"];
            generalCell.generalLabel.text = @"到达机场";
            generalCell.generalValue.titleLabel.text = @"不限";
            self.arriveAirportCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 4) {
            // 起飞时间段
            generalCell.generalIcon.image = [UIImage imageNamed:@"TakeOffTime"];
            generalCell.generalLabel.text = @"起飞时间";
            generalCell.generalValue.titleLabel.text = @"不限";
            self.takeOffTimeCell = generalCell;
        }
        //        generalCell.generalValue.titleLabel.text = @"不限";
    }
    return generalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isShowMore) return;
    
    NSInteger beginOptionCounter = 3;
    if (isReturn) beginOptionCounter++;
    // 若PickerView已经展示则隐藏，不做任何更改
    if (CGRectEqualToRect(self.optionSelectPickerView.frame, SHOW_PICKER_VIEW_FRAME)) {
        [UIView animateWithDuration:TOOLBAR_PICKER_ANIMATION_SPEED animations:^{
            [self hideToolBarAndPickerWithAnimation:NO];
        } completion:^(BOOL finished) {
            if (indexPath.row == beginOptionCounter) {
                [self showPickerForAirlineSelect];
            } else if (indexPath.row == beginOptionCounter + 1) {
                [self showPickerForSeatSelect];
            } else if (indexPath.row == beginOptionCounter + 2) {
                [self showPickerForDepartAirportSelect];
            } else if (indexPath.row == beginOptionCounter + 3) {
                [self showPickerForArriveAirportSelect];
            } else if (indexPath.row == beginOptionCounter + 4) {
                [self showPickerForTakeOffTimeSelect];
            }
        }];
    } else {
        if (indexPath.row == beginOptionCounter) {
            [self showPickerForAirlineSelect];
        } else if (indexPath.row == beginOptionCounter + 1) {
            [self showPickerForSeatSelect];
        } else if (indexPath.row == beginOptionCounter + 2) {
            [self showPickerForDepartAirportSelect];
        } else if (indexPath.row == beginOptionCounter + 3) {
            [self showPickerForArriveAirportSelect];
        } else if (indexPath.row == beginOptionCounter + 4) {
            [self showPickerForTakeOffTimeSelect];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerData objectAtIndex:row];
}

#pragma mark - Helper Methods

- (void)showToolBarAndPickerWithAnimation:(BOOL)animate
{
    if (animate) {
        [UIView beginAnimations:nil context:nil];
        [self.optionSelectToolBar setFrame:SHOW_TOOL_BAR_VIEW_FRAME];
        [self.optionSelectPickerView setFrame:SHOW_PICKER_VIEW_FRAME];
        [UIView commitAnimations];
    } else {
        [self.optionSelectToolBar setFrame:SHOW_TOOL_BAR_VIEW_FRAME];
        [self.optionSelectPickerView setFrame:SHOW_PICKER_VIEW_FRAME];
    }
}

- (void)hideToolBarAndPickerWithAnimation:(BOOL)animate
{
    if (animate) {
        [UIView beginAnimations:nil context:nil];
        [self.optionSelectToolBar setFrame:HIDE_TOOL_BAR_VIEW_FRAME];
        [self.optionSelectPickerView setFrame:HIDE_PICKER_VIEW_FRAME];
        [UIView commitAnimations];
    } else {
        [self.optionSelectToolBar setFrame:HIDE_TOOL_BAR_VIEW_FRAME];
        [self.optionSelectPickerView setFrame:HIDE_PICKER_VIEW_FRAME];
    }
}

- (void)showPickerForAirlineSelect
{
    selectingOption = SelectingAirline;
    
    NSMutableArray *airlineData = [NSMutableArray arrayWithObject:@"不限"];
    [airlineData addObjectsFromArray:[[[APIResourceHelper sharedResourceHelper] findAllAirlineShortNames] mutableCopy]];
    
    self.pickerData = airlineData;
    [self.optionSelectPickerView reloadAllComponents];
    [self.optionSelectPickerView selectRow:[self.pickerData indexOfObject:self.airlineCell.generalValue.titleLabel.text] inComponent:0 animated:NO];
    [self showToolBarAndPickerWithAnimation:YES];
}

- (void)showPickerForSeatSelect
{
    selectingOption = SelectingSeat;
    
    self.pickerData = [cSeatTypeGet copy];
    [self.optionSelectPickerView reloadAllComponents];
    [self.optionSelectPickerView selectRow:[self.pickerData indexOfObject:self.seatCell.generalValue.titleLabel.text] inComponent:0 animated:NO];
    [self showToolBarAndPickerWithAnimation:YES];
}

- (void)showPickerForDepartAirportSelect
{
    selectingOption = SelectingDepartAirport;
    
    NSMutableArray *airportData = [NSMutableArray arrayWithObject:@"不限"];
    [airportData addObjectsFromArray:[[[APIResourceHelper sharedResourceHelper] findAirportsNameInCity:self.fromToCell.fromCityLabel.text] mutableCopy]];
    
    self.pickerData = airportData;
    [self.optionSelectPickerView reloadAllComponents];
    [self.optionSelectPickerView selectRow:[self.pickerData indexOfObject:self.departAirportCell.generalValue.titleLabel.text] inComponent:0 animated:NO];
    [self showToolBarAndPickerWithAnimation:YES];
}

- (void)showPickerForArriveAirportSelect
{
    selectingOption = SelectingArriveAirport;
    
    NSMutableArray *airportData = [NSMutableArray arrayWithObject:@"不限"];
    [airportData addObjectsFromArray:[[[APIResourceHelper sharedResourceHelper] findAirportsNameInCity:self.fromToCell.toCityLabel.text] mutableCopy]];
    
    self.pickerData = airportData;
    [self.optionSelectPickerView reloadAllComponents];
    [self.optionSelectPickerView selectRow:[self.pickerData indexOfObject:self.arriveAirportCell.generalValue.titleLabel.text] inComponent:0 animated:NO];
    [self showToolBarAndPickerWithAnimation:YES];
}

- (void)showPickerForTakeOffTimeSelect
{
    selectingOption = SelectingTakeOffTime;
    
    self.pickerData = [cTakeOffTimeScopeGet copy];
    [self.optionSelectPickerView reloadAllComponents];
    [self.optionSelectPickerView selectRow:[self.pickerData indexOfObject:self.takeOffTimeCell.generalValue.titleLabel.text] inComponent:0 animated:NO];
    [self showToolBarAndPickerWithAnimation:YES];
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
