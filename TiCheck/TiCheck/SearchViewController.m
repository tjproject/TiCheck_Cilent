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
#import "UIImage+ImageResize.h"
#import "APIResourceHelper.h"
#import "Airline.h"
#import "AppDelegate.h"
#import "CommonData.h"
#import "ServerCommunicator.h"

extern NSDictionary *notificationOption;

extern NSString *mDeviceToken;

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, CitySelectViewControllerDelegate, DateSelectViewControllerDelegate>
{
    UIView *darkUILayer;
}
@property (weak, nonatomic) IBOutlet UITableView *searchOptionTableView;

@property (weak, nonatomic) IBOutlet UIToolbar *optionSelectToolBar;
@property (weak, nonatomic) IBOutlet UIPickerView *optionSelectPickerView;

@property (weak, nonatomic) FromToTableViewCell *fromToCell;
@property (weak, nonatomic) DateTableViewCell *takeOffDateCell;
@property (weak, nonatomic) DateTableViewCell *returnDateCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *airlineCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *seatCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *departAirportCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *arriveAirportCell;
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
    [self initDarkUILayer];

    if (mDeviceToken != NULL) {
       [[ServerCommunicator sharedCommunicator] addTokenForCurrentUser:mDeviceToken];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (notificationOption != nil) {
        [self closeButtonPressed:nil];
    }
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

- (void)initDarkUILayer
{
    darkUILayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    darkUILayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    darkUILayer.userInteractionEnabled = NO;
    [_searchOptionTableView addSubview:darkUILayer];
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
    [self presentViewController:viewController animated:YES completion:nil];
}

- (NSArray *)getAllAirlineWithShortName
{
    NSDictionary *getAllAirlineResponseDic = [[ServerCommunicator sharedCommunicator] getAllAirlineCompany];
    NSInteger returnCode = [getAllAirlineResponseDic[SERVER_RETURN_CODE_KEY] integerValue];
    NSMutableArray *airlineShortNames = [NSMutableArray arrayWithObject:@"不限"];
    
    if (returnCode == 1) {
        [airlineShortNames addObjectsFromArray:[[APIResourceHelper sharedResourceHelper] findAllAirlineShortNamesViaAirlineDibitCode:getAllAirlineResponseDic[SERVER_USER_DATA]]];
    } else {
        airlineShortNames = [NSMutableArray arrayWithObject:@"载入失败"];
    }
    return  airlineShortNames;
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
        [self.departAirportCell.generalValue setTitle:@"不限" forState:UIControlStateNormal];
    }
}

- (void)setToCityLabel:(NSString *)toCityString
{
    self.fromToCell.toCityLabel.text = toCityString;
    [SearchOption sharedSearchOption].arriveCityName = self.fromToCell.toCityLabel.text;
    if (isShowMore) {
        [self.arriveAirportCell.generalValue setTitle:@"不限" forState:UIControlStateNormal];
    }
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
    NSInteger result = 5;
    
    if (isReturn) result++;
    if (isShowMore) result += MORE_OPTION_COUNT - 1;
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fromToCellIdentifier = @"FromToCell";
    static NSString *dateCellIdentifier = @"DateCell";
//    static NSString *isReturnCellIdentifier = @"IsReturnCell";
    static NSString *exchangeCityCellIdentifier = @"ExchangeCityCell";
    static NSString *showMoreCellIdentifier = @"ShowMoreCell";
    static NSString *generalOptionCellIdentifier = @"GeneralOptionCell";
    static NSString *confirmCellIdentifier = @"ConfirmButtonCell";
    
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
        
        fromToCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        
        takeOffDateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return takeOffDateCell;
    } else {
        NSInteger isReturnIndexRow = 2; // 现在用于交换城市IndexRow
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
                
                returnDateCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return returnDateCell;
            }
        }
        // 是否返程Option
        if (indexPath.row == isReturnIndexRow) {
            UITableViewCell *isReturnCell = [tableView dequeueReusableCellWithIdentifier:exchangeCityCellIdentifier
                                                                            forIndexPath:indexPath];
            isReturnCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            showMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return showMoreCell;
        }
    } else {
        if (indexPath.row == moreOptionIndexRow) {
            // Airline选项
            generalCell.generalIcon.image = [UIImage imageNamed:@"Airline"];
            generalCell.generalLabel.text = @"航空公司";
            [generalCell.generalValue setTitle:@"不限" forState:UIControlStateNormal];
            self.airlineCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 1) {
            // 舱位选项
            generalCell.generalIcon.image = [UIImage imageNamed:@"Seat"];
            generalCell.generalLabel.text = @"舱位";
            [generalCell.generalValue setTitle:@"不限" forState:UIControlStateNormal];
            self.seatCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 2) {
            // 机场选择
            generalCell.generalIcon.image = [UIImage imageNamed:@"Airport"];
            generalCell.generalLabel.text = @"出发机场";
            [generalCell.generalValue setTitle:@"不限" forState:UIControlStateNormal];
            self.departAirportCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 3) {
            generalCell.generalIcon.image = [UIImage imageNamed:@"Airport"];
            generalCell.generalLabel.text = @"到达机场";
            [generalCell.generalValue setTitle:@"不限" forState:UIControlStateNormal];
            self.arriveAirportCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 4) {
            // 起飞时间段
            generalCell.generalIcon.image = [UIImage imageNamed:@"TakeOffTime"];
            generalCell.generalLabel.text = @"起飞时间";
            [generalCell.generalValue setTitle:@"不限" forState:UIControlStateNormal];
            self.takeOffTimeCell = generalCell;
        }
        
        generalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return generalCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:confirmCellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNum = 4;
    CGFloat confirmButtonCellHeight = CONFIRM_BUTTON_CELL_HEIGHT;
    
    if (isReturn) {
        rowNum++;
        confirmButtonCellHeight = 284.0f;
    }
    if (isShowMore) {
        rowNum = rowNum + MORE_OPTION_COUNT - 1;
        confirmButtonCellHeight = 152.0f;
    }
    if (isReturn && isShowMore) confirmButtonCellHeight = 140.0f;
    
    if (indexPath.row == rowNum) return confirmButtonCellHeight;
    return 44.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//
//{return 0.1;}

#pragma mark Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerData objectAtIndex:row];
}

#pragma mark - Component event

- (IBAction)searchTicket:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([appDelegate.hostReachability currentReachabilityStatus] != NotReachable) {
            NSString *airlineShortName = self.airlineCell.generalValue.titleLabel.text;
            Airline *airline = [[APIResourceHelper sharedResourceHelper] findAirlineViaAirlineShortName:airlineShortName];
            [[ServerCommunicator sharedCommunicator] addAirlineCount:airline];
        }
    });
}

- (IBAction)moreOptionClicked:(id)sender
{
    NSLog(@"%f", self.searchOptionTableView.frame.size.height);
    isShowMore = YES;
    NSLog(@"%f", self.searchOptionTableView.frame.size.height);
    NSInteger moreOptionsBeginCounter = 3;
    if (isReturn) moreOptionsBeginCounter++;
    
    NSMutableArray *moreOptionIndexArray = [NSMutableArray array];
    for (NSInteger i = 0; i < MORE_OPTION_COUNT; ++i) {
        NSIndexPath *toAddOption = [NSIndexPath indexPathForRow:moreOptionsBeginCounter + i inSection:0];
        [moreOptionIndexArray addObject:toAddOption];
    }
    
    NSIndexPath *moreButton = [NSIndexPath indexPathForRow:moreOptionsBeginCounter inSection:0];

    [self.searchOptionTableView beginUpdates];
    [self.searchOptionTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:moreButton] withRowAnimation:UITableViewRowAnimationTop];
    [self.searchOptionTableView insertRowsAtIndexPaths:moreOptionIndexArray withRowAnimation:UITableViewRowAnimationTop];
    [self.searchOptionTableView endUpdates];
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
    } else {
        [self.searchOptionTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:returnIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (IBAction)exchangeCityClicked:(id)sender
{
    CGRect fromCityFrame = self.fromToCell.fromCityLabel.frame;
    CGRect toCityFrame = self.fromToCell.toCityLabel.frame;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.fromToCell.fromCityLabel.frame = toCityFrame;
        self.fromToCell.toCityLabel.frame = fromCityFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.fromToCell.fromCityLabel.frame = fromCityFrame;
            self.fromToCell.toCityLabel.frame = toCityFrame;
            
            NSString *fromCityName = self.fromToCell.fromCityLabel.text;
            self.fromToCell.fromCityLabel.text = self.fromToCell.toCityLabel.text;
            self.fromToCell.toCityLabel.text = fromCityName;
        }
    }];
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
        {
            [self.airlineCell.generalValue setTitle:selectValue forState:UIControlStateNormal];
            NSString *airlineShortName = [[APIResourceHelper sharedResourceHelper] findAirlineViaAirlineShortName:self.airlineCell.generalValue.titleLabel.text].airline;
            UIImage *airlineImg = [UIImage imageWithImage:[UIImage imageNamed:airlineShortName] scaledToSize:AIRLINE_CELL_IMAGE_SIZE];
            [self.airlineCell.generalValue setImage:airlineImg forState:UIControlStateNormal];
            break;
        }
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
        darkUILayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
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
        darkUILayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView commitAnimations];
    } else {
        [self.optionSelectToolBar setFrame:HIDE_TOOL_BAR_VIEW_FRAME];
        [self.optionSelectPickerView setFrame:HIDE_PICKER_VIEW_FRAME];
    }
}

- (void)showPickerForAirlineSelect
{
    selectingOption = SelectingAirline;
    
    if ([APIResourceHelper sharedResourceHelper].airlineShortNameFromServer == nil) {
        self.pickerData = @[@"不限", @"载入中..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [APIResourceHelper sharedResourceHelper].airlineShortNameFromServer = [self getAllAirlineWithShortName];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (selectingOption == SelectingAirline) {
                    self.pickerData = [APIResourceHelper sharedResourceHelper].airlineShortNameFromServer;
                    [self.optionSelectPickerView reloadAllComponents];
                }
            });
        });
    }
    else {
        self.pickerData = [APIResourceHelper sharedResourceHelper].airlineShortNameFromServer;
    }
    
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
            [optionDic setObject:self.departAirportCell.generalValue.titleLabel.text forKey:DEPART_AIRPORT_KEY];
            [optionDic setObject:self.arriveAirportCell.generalValue.titleLabel.text forKey:ARRIVE_AIRPORT_KEY];
            [optionDic setObject:self.takeOffTimeCell.generalValue.titleLabel.text forKey:TAKE_OFF_TIME_INTERVAL_KEY];
        }
        vc.searchOptionDic = optionDic;
        vc.isShowMore = isShowMore;
    }
}

@end
