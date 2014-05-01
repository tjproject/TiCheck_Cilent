//
//  SearchViewController.m
//  TiCheck
//
//  Created by Boyi on 4/20/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "SearchOption.h"
#import "PersonalCenterViewController.h"

#import "CommonData.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, CitySelectViewControllerDelegate, DateSelectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchOptionTableView;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIToolbar *optionSelectToolBar;
@property (weak, nonatomic) IBOutlet UIPickerView *optionSelectPickerView;

@property (weak, nonatomic) FromToTableViewCell *fromToCell;
@property (weak, nonatomic) DateTableViewCell *takeOffDateCell;
@property (weak, nonatomic) DateTableViewCell *returnDateCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *airlineCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *seatCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *airportCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *takeOffTimeCell;

@property (nonatomic, strong) NSArray *pickerData;

@end

@implementation SearchViewController
{
    BOOL isReturn; // 是否返程
    BOOL isShowMore; // 是否显示更多
    
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
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TiCheckTitle"]];
        [self.optionSelectPickerView setFrame:HIDE_PICKER_VIEW_FRAME];
    [self initNavBar];
}

- (void)initNavBar
{
    UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 22)];
    [tempBtn setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:tempBtn];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = closeButton;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self synchronizeSaveSearchOption];
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

#pragma mark - 选项gesture

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
    } else if (label == self.takeOffDateCell.dateLabel) {
        DateSelectViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelectViewController"];
        
        dateViewController.selectedDate = [NSString dateFormatWithString:self.takeOffDateCell.dateLabel.text];
        dateViewController.delegate = self;
        dateViewController.routeType = Take_Off;
        dateViewController.beginDate = [NSDate date];
        dateViewController.isTodayButtonHidden = NO;
        
        [self presentViewController:dateViewController animated:YES completion:nil];
    } else if (label == self.returnDateCell.dateLabel) {
        DateSelectViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelectViewController"];
        
        dateViewController.selectedDate = [NSString dateFormatWithString:self.returnDateCell.dateLabel.text];
        dateViewController.delegate = self;
        dateViewController.routeType = Return;
        dateViewController.beginDate = [NSString dateFormatWithString:self.takeOffDateCell.dateLabel.text];
        dateViewController.isTodayButtonHidden = YES;
        
        [self presentViewController:dateViewController animated:YES completion:nil];
    }
}

#pragma mark - delegate

- (void)setFromCityLabel:(NSString *)fromCityString
{
    self.fromToCell.fromCityLabel.text = fromCityString;
    [SearchOption sharedSearchOption].departCityName = self.fromToCell.fromCityLabel.text;
    
    if (isShowMore) {
        // 重选出发城市默认机场为不限
        [self.airportCell.generalValue setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setToCityLabel:(NSString *)toCityString
{
    self.fromToCell.toCityLabel.text = toCityString;
    [SearchOption sharedSearchOption].arriveCityName = self.fromToCell.toCityLabel.text;
}

- (void)setTakeOffTimeLabel:(NSDate *)takeOffDate
{
    self.takeOffDateCell.dateLabel.text = [NSString stringFormatWithDate:takeOffDate];
    // 若选择开始时间晚于结束时间，调整结束时间为开始时间
    if (isReturn && [takeOffDate isLaterThanDate:[NSString dateFormatWithString:self.returnDateCell.dateLabel.text]]) {
        self.returnDateCell.dateLabel.text = [NSString stringFormatWithDate:takeOffDate];
    }
    [SearchOption sharedSearchOption].takeOffDate = [NSString dateFormatWithString:self.takeOffDateCell.dateLabel.text];
}

- (void)setReturnTimeLabel:(NSDate *)returnDate
{
    self.returnDateCell.dateLabel.text = [NSString stringFormatWithDate:returnDate];
    [SearchOption sharedSearchOption].returnDate = [NSString dateFormatWithString:self.returnDateCell.dateLabel.text];
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
    static NSString *dateCellIdentifier = @"DateCell";
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
        self.fromToCell.fromCityLabel.text = [SearchOption sharedSearchOption].departCityName;
        self.fromToCell.toCityLabel.text = [SearchOption sharedSearchOption].arriveCityName;
        
        return fromToCell;
    } else if (indexPath.row == 1) {
        // TakeOffDate选项
        DateTableViewCell *takeOffDateCell = [tableView dequeueReusableCellWithIdentifier:dateCellIdentifier];
        if (takeOffDateCell == nil) {
            takeOffDateCell = [[DateTableViewCell alloc] init];
        }
        
        self.takeOffDateCell = takeOffDateCell;
        UITapGestureRecognizer *takeOffDateSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
        [self.takeOffDateCell.dateLabel addGestureRecognizer:takeOffDateSelectGesture];
        self.takeOffDateCell.dateLabel.text = [NSString stringFormatWithDate:[SearchOption sharedSearchOption].takeOffDate];
        
        return takeOffDateCell;
    } else {
        NSInteger isReturnIndexRow = 2;
        // 若为返程则第二行为返程时间
        if (isReturn) {
            isReturnIndexRow++;
            if (indexPath.row == 2) {
                DateTableViewCell *returnDateCell = [tableView dequeueReusableCellWithIdentifier:dateCellIdentifier];
                if (returnDateCell == nil) {
                    returnDateCell = [[DateTableViewCell alloc] init];
                }
                
                self.returnDateCell = returnDateCell;
                UITapGestureRecognizer *returnDateSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
                [self.returnDateCell.dateLabel addGestureRecognizer:returnDateSelectGesture];
                self.returnDateCell.dateLabel.text = [NSString stringFormatWithDate:[SearchOption sharedSearchOption].returnDate];
                // 显示返回日期时，若早于出发时期，调整至出发日期
                if ([[NSString dateFormatWithString:self.returnDateCell.dateLabel.text] isEarlierThanDate:[NSString dateFormatWithString:self.takeOffDateCell.dateLabel.text]]) {
                    self.returnDateCell.dateLabel.text = self.takeOffDateCell.dateLabel.text;
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
            // 机场选择
            generalCell.generalIcon.image = [UIImage imageNamed:@"Airport"];
            generalCell.generalLabel.text = @"机场";
            generalCell.generalValue.titleLabel.text = @"不限";
            self.airportCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 3) {
            // 起飞时间段
            generalCell.generalIcon.image = [UIImage imageNamed:@"TakeOffTime"];
            generalCell.generalLabel.text = @"起飞时间";
            generalCell.generalValue.titleLabel.text = @"不限";
            self.takeOffTimeCell = generalCell;
        }
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
                [self showPickerForAirportSelect];
            } else if (indexPath.row == beginOptionCounter + 3) {
                [self showPickerForTakeOffTimeSelect];
            }
        }];
    } else {
        if (indexPath.row == beginOptionCounter) {
            [self showPickerForAirlineSelect];
        } else if (indexPath.row == beginOptionCounter + 1) {
            [self showPickerForSeatSelect];
        } else if (indexPath.row == beginOptionCounter + 2) {
            [self showPickerForAirportSelect];
        } else if (indexPath.row == beginOptionCounter + 3) {
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

#pragma mark - Component event

- (IBAction)searchTicket:(id)sender
{
    
}

- (IBAction)moreOptionClicked:(id)sender
{
    isShowMore = YES;
    
    NSInteger moreOptionsBeginCounter = 3;
    if (isReturn) moreOptionsBeginCounter++;
    
    NSMutableArray *moreOptionIndexArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; ++i) {
        NSIndexPath *toAddOption = [NSIndexPath indexPathForRow:moreOptionsBeginCounter + i inSection:0];
        [moreOptionIndexArray addObject:toAddOption];
    }
    
    NSIndexPath *moreButton = [NSIndexPath indexPathForRow:moreOptionsBeginCounter inSection:0];

    [self.searchOptionTableView beginUpdates];
    [self.searchOptionTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:moreButton] withRowAnimation:UITableViewRowAnimationTop];
    [self.searchOptionTableView insertRowsAtIndexPaths:moreOptionIndexArray withRowAnimation:UITableViewRowAnimationTop];
    [self.searchOptionTableView endUpdates];
    
    if (isReturn) {
        [UIView animateWithDuration:0.3f animations:^{
            self.buttonsView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * MORE_OPTION_COUNT * 2);
            [self.buttonsView layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.buttonsView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * (MORE_OPTION_COUNT - 1) * 2);
            [self.buttonsView layoutIfNeeded];
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
        [self.searchOptionTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:returnIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (isShowMore) {
            [UIView animateWithDuration:0.3f animations:^{
                self.buttonsView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * MORE_OPTION_COUNT * 2);
                [self.buttonsView layoutIfNeeded];
            }];
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                self.buttonsView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * 2);
                [self.buttonsView layoutIfNeeded];
            }];
        }
    } else {
        [self.searchOptionTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:returnIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
          
        if (isShowMore) {
            [UIView animateWithDuration:0.3f animations:^{
                self.buttonsView.transform = CGAffineTransformMakeTranslation(0, TABLE_VIEW_DEFAULT_HEIGHT * (MORE_OPTION_COUNT - 1) * 2);
                [self.buttonsView layoutIfNeeded];
            }];
        } else {
            [UIView animateWithDuration:0.3f animations:^{
                self.buttonsView.transform = CGAffineTransformMakeTranslation(0, 0);
                [self.buttonsView layoutIfNeeded];
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
        case SelectingAirport:
            [self.airportCell.generalValue setTitle:selectValue forState:UIControlStateNormal];
            break;
        case SelectingTakeOffTime:
            [self.takeOffTimeCell.generalValue setTitle:selectValue forState:UIControlStateNormal];
            break;
    }
    
    [self hideToolBarAndPickerWithAnimation:YES];
}

#pragma mark - Helper Methods

- (void)synchronizeSaveSearchOption
{
    [SearchOption sharedSearchOption].departCityName = self.fromToCell.fromCityLabel.text;
    [SearchOption sharedSearchOption].arriveCityName = self.fromToCell.toCityLabel.text;
    [SearchOption sharedSearchOption].takeOffDate = [NSString dateFormatWithString:self.takeOffDateCell.dateLabel.text];
    if (isReturn)
        [SearchOption sharedSearchOption].returnDate = [NSString dateFormatWithString:self.returnDateCell.dateLabel.text];
}

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

- (void)showPickerForAirportSelect
{
    selectingOption = SelectingAirport;
    
    NSMutableArray *airportData = [NSMutableArray arrayWithObject:@"不限"];
    [airportData addObjectsFromArray:[[[APIResourceHelper sharedResourceHelper] findAirportsNameInCity:self.fromToCell.fromCityLabel.text] mutableCopy]];
    
    self.pickerData = airportData;
    [self.optionSelectPickerView reloadAllComponents];
    [self.optionSelectPickerView selectRow:[self.pickerData indexOfObject:self.airportCell.generalValue.titleLabel.text] inComponent:0 animated:NO];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        SearchResultViewController *vc = [segue destinationViewController];
        
        NSMutableDictionary *optionDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.fromToCell.fromCityLabel.text, FROM_CITY_KEY, self.fromToCell.toCityLabel.text, TO_CITY_KEY, self.takeOffDateCell.dateLabel.text, TAKE_OFF_TIME_KEY, @(isShowMore), HAS_MORE_OPTION_KEY, nil];
        if (isReturn) {
            [optionDic setObject:self.returnDateCell.dateLabel.text forKey:RETURN_TIME_KEY];
        }
        if (isShowMore) {
            [optionDic setObject:self.airlineCell.generalValue.titleLabel.text forKey:AIRLINE_KEY];
            [optionDic setObject:self.seatCell.generalValue.titleLabel.text forKey:SEAT_TYPE_KEY];
            [optionDic setObject:self.airportCell.generalValue.titleLabel.text forKey:AIRPORT_KEY];
            [optionDic setObject:self.takeOffTimeCell.generalValue.titleLabel.text forKey:TAKE_OFF_TIME_INTERVAL_KEY];
        }
        vc.searchOptionDic = optionDic;
    }
}

@end
