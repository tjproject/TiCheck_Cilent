//
//  CitySelectViewController.m
//  TiCheck
//
//  Created by Boyi on 4/20/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "CitySelectViewController.h"
#import "APIResourceHelper.h"
#import "pinyin.h"
#import "DomesticCity.h"

@interface CitySelectViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *citySearchBar;
@property (strong, nonatomic) UISearchDisplayController *citySearchDisplayControl;

@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSArray *sectionHeaderKeys;

@property (strong, nonatomic) NSArray *resultCities;

@end

@implementation CitySelectViewController {
    BOOL isSearching;
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
    
    isSearching = NO;
    
    [self initCityDataWithDomesticCityArray:[[APIResourceHelper sharedResourceHelper] findAllCityNameContainsAirport]];
    self.citySearchDisplayControl = [[UISearchDisplayController alloc] initWithSearchBar:self.citySearchBar
                                                                      contentsController:self];
    self.citySearchDisplayControl.delegate = self;
    self.citySearchDisplayControl.searchResultsDelegate = self;
    self.citySearchDisplayControl.searchResultsDataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching) {
        return [self.resultCities count];
    } else {
        return [[self.cities objectAtIndex:section] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSearching) {
        return 1;
    } else {
        return [self.cities count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isSearching) {
        return @"";
    } else {
        return self.sectionHeaderKeys[section];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching) {
        return [NSArray array];
    } else {
        return self.sectionHeaderKeys;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (isSearching) {
        if ([self.resultCities count] > indexPath.row) {
            NSString *str = [self.resultCities objectAtIndex:indexPath.row];
            cell.textLabel.text = str;
        }
    } else {
        if ([self.cities count] > indexPath.section) {
            NSArray *array = [self.cities objectAtIndex:indexPath.section];
            if ([array count] > indexPath.row) {
                DomesticCity *str = (DomesticCity *)[array objectAtIndex:indexPath.row];
                cell.textLabel.text = str.cityName;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (self.selectCityType) {
        case From_City:
            [self.delegate setFromCityLabel:cell.textLabel.text];
            break;
        case To_City:
            [self.delegate setToCityLabel:cell.textLabel.text];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.citySearchBar resignFirstResponder];
}

#pragma mark SearchBar & SearchDisplay Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.resultCities = [NSArray array];
    
    if ([searchText length] != 0) {
        isSearching = YES;
        
        [self searchResultTableList];
    } else {
        isSearching = NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    isSearching = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchResultTableList];
}

#pragma mark - Helper Method

- (void)searchResultTableList
{
    NSString *searchString = self.citySearchBar.text;
    NSMutableArray *tempResultArray = [NSMutableArray array];
    
    for (NSArray *DomesticCityGroup in self.cities) {
        for (DomesticCity *domesticCity in DomesticCityGroup) {
            NSComparisonResult pinyinResult = [domesticCity.cityEName compare:searchString options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            NSComparisonResult stringResult = [domesticCity.cityName compare:searchString options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length]) locale:[NSLocale currentLocale]];
            NSComparisonResult shortNameResult = [domesticCity.cityShortName compare:searchString options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            if (pinyinResult == NSOrderedSame || stringResult == NSOrderedSame || shortNameResult == NSOrderedSame) {
                [tempResultArray addObject:domesticCity.cityName];
            }
        }
    }
    
    self.resultCities = tempResultArray;
}

- (void)initCityDataWithDomesticCityArray:(NSArray *)unsortedCities
{
    NSMutableArray *domesticCityArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [unsortedCities count]; ++i) {
        DomesticCity *domesticCity = [[DomesticCity alloc] init];
        domesticCity.cityName = [NSString stringWithString:unsortedCities[i]];
        
        if (domesticCity.cityName == nil) {
            domesticCity.cityName = @"";
        }
        
        if (![domesticCity.cityName isEqualToString:@""]) {
            // 三种筛选方式，中文名（未测试），拼音，拼音简写
            DomesticCity *searchedCity = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:domesticCity.cityName];
            if (searchedCity.cityEName == nil || [searchedCity.cityEName isEqualToString:@""]) {
                domesticCity.cityEName = [self getChineseStringPinyin:domesticCity.cityName];
            } else {
                domesticCity.cityEName = searchedCity.cityEName;
            }
            domesticCity.cityShortName = [self getChineseStringPinyin:domesticCity.cityName];
        } else {
            domesticCity.cityEName = @"";
        }
        
        [domesticCityArray addObject:domesticCity];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"cityEName" ascending:YES]];
    [domesticCityArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex = NO;
    NSMutableArray *tempArrayForGrouping = nil;
    NSMutableArray *tempSectionHeader = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [domesticCityArray count]; ++i) {
        DomesticCity *domesticCity = (DomesticCity *)(domesticCityArray[i]);
        NSMutableString *strChar = [NSMutableString stringWithString:domesticCity.cityEName];
        NSString *sr = [strChar substringToIndex:1]; // 只使用第一个字母进行比较
        
        if (![tempSectionHeader containsObject:[sr uppercaseString]]) {
            [tempSectionHeader addObject:[sr uppercaseString]];
            tempArrayForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if ([tempSectionHeader containsObject:[sr uppercaseString]]) {
            [tempArrayForGrouping addObject:domesticCityArray[i]];
            if (checkValueAtIndex == NO) {
                [arrayForArrays addObject:tempArrayForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    
    self.sectionHeaderKeys = tempSectionHeader;
    self.cities = arrayForArrays;
}

- (NSString *)getChineseStringPinyin:(NSString *)DomesticCity
{
    NSString *result = @"";
    
    for (NSInteger i = 0; i < [DomesticCity length]; ++i) {
        NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([DomesticCity characterAtIndex:i])] uppercaseString];
        result = [result stringByAppendingString:singlePinyinLetter];
    }
    
    return result;
}

#pragma mark - Keyboard Show and Hide

- (void)keyboardDidShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    CGSize size = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect frame = CGRectMake(self.tableView.frame.origin.x,
                              self.tableView.frame.origin.y,
                              self.tableView.frame.size.width,
                              self.tableView.frame.size.height - size.height);
    self.tableView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    CGSize size = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect frame = CGRectMake(self.tableView.frame.origin.x,
                              self.tableView.frame.origin.y,
                              self.tableView.frame.size.width,
                              self.tableView.frame.size.height + size.height);
    self.tableView.frame = frame;
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
