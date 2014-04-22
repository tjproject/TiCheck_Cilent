//
//  SearchViewController.m
//  TiCheck
//
//  Created by Boyi on 4/20/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "CitySelectViewController.h"
#import "DateSelectViewController.h"
#import "DateSelectViewController.h"
#import "NSString+DateFormat.h"
#import "SearchOption.h"

#import "DateTableViewCell.h"
#import "FromToTableViewCell.h"
#import "GeneralOptionTableViewCell.h"

#define TABLE_VIEW_DEFAULT_HEIGHT 44.0f
#define MORE_OPTION_COUNT 4

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource ,CitySelectViewControllerDelegate, DateSelectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchOptionTableView;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet UIButton *lowPriceButton;
@property (weak, nonatomic) IBOutlet UIButton *myOrderButton;

@property (weak, nonatomic) FromToTableViewCell *fromToCell;
@property (weak, nonatomic) DateTableViewCell *takeOffDateCell;
@property (weak, nonatomic) DateTableViewCell *returnDateCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *airlineCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *seatCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *airportCell;
@property (weak, nonatomic) GeneralOptionTableViewCell *takeOffTimeCell;

@end

@implementation SearchViewController
{
    BOOL isReturn; // 是否返程
    BOOL isShowMore; // 是否显示更多
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (void)synchronizeSaveSearchOption
{
    [SearchOption sharedSearchOption].departCityName = self.fromToCell.fromCityLabel.text;
    [SearchOption sharedSearchOption].arriveCityName = self.fromToCell.toCityLabel.text;
    [SearchOption sharedSearchOption].takeOffDate = [NSString dateFormatWithString:self.takeOffDateCell.dateLabel.text];
    [SearchOption sharedSearchOption].returnDate = [NSString dateFormatWithString:self.returnDateCell.dateLabel.text];
}

#pragma mark - 选项gesture

- (void)optionLabelTapped:(UITapGestureRecognizer *)sender
{
    UILabel *label = (UILabel *)sender.view;

//    NSLog(@"%dsdadsa");
//    FromToTableViewCell *fromToCell = (FromToTableViewCell *)[self.searchOptionTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
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
        
        [self presentViewController:dateViewController animated:YES completion:nil];
    } else if (label == self.returnDateCell.dateLabel) {
        DateSelectViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelectViewController"];
        
        dateViewController.selectedDate = [NSString dateFormatWithString:self.returnDateCell.dateLabel.text];
        dateViewController.delegate = self;
        dateViewController.routeType = Return;
        dateViewController.beginDate = [NSString dateFormatWithString:self.takeOffDateCell.dateLabel.text];
        
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
    self.takeOffDateCell.dateLabel.text = [NSString stringFormatWithDate:takeOffDate];
}

- (void)setReturnTimeLabel:(NSDate *)returnDate
{
    self.returnDateCell.dateLabel.text = [NSString stringFormatWithDate:returnDate];
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 4;
    
    if (isReturn) result++;
    if (isShowMore) result += 3;
    
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
            [generalCell.generalValue setTitle:@"东方航空" forState:UIControlStateNormal];
            [generalCell.generalValue setImage:[UIImage imageNamed:@"EA_Logo"] forState:UIControlStateNormal];
            self.airlineCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 1) {
            // 舱位选项
            generalCell.generalIcon.image = [UIImage imageNamed:@"Seat"];
            generalCell.generalLabel.text = @"舱位";
            generalCell.generalValue.titleLabel.text = @"经济舱";
            self.seatCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 2) {
            // 机场选择
            generalCell.generalIcon.image = [UIImage imageNamed:@"Airport"];
            generalCell.generalLabel.text = @"机场";
            generalCell.generalValue.titleLabel.text = @"浦东机场";
            self.airportCell = generalCell;
        } else if (indexPath.row == moreOptionIndexRow + 3) {
            // 起飞时间段
            generalCell.generalIcon.image = [UIImage imageNamed:@"TakeOffTime"];
            generalCell.generalLabel.text = @"起飞时间";
            generalCell.generalValue.titleLabel.text = @"9:00 ~ 12:00";
            self.takeOffTimeCell = generalCell;
        }
//        generalCell.generalValue.titleLabel.text = @"不限";
    }
    return generalCell;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        SearchResultViewController *vc = [segue destinationViewController];
        
        NSMutableDictionary *optionDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.fromToCell.fromCityLabel.text, FROM_CITY_KEY, self.fromToCell.toCityLabel.text, TO_CITY_KEY, self.takeOffDateCell.dateLabel.text, TAKE_OFF_TIME_KEY, nil];
        vc.searchOptionDic = optionDic;
    }
}

@end
