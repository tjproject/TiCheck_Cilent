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

@interface SearchViewController () <CitySelectViewControllerDelegate, DateSelectViewControllerDelegate>

@end

@implementation SearchViewController

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
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TiCheckTitle"]];
    [self synchronizeSetSearchOption];
    
    UITapGestureRecognizer *fromSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
    UITapGestureRecognizer *toSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
    UITapGestureRecognizer *takeOffTimeSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionLabelTapped:)];
    
    [self.fromCity addGestureRecognizer:fromSelectGesture];
    [self.toCity addGestureRecognizer:toSelectGesture];
    [self.takeOffTime addGestureRecognizer:takeOffTimeSelectGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self synchronizeSaveSearchOption];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)synchronizeSetSearchOption
{
    self.fromCity.text = [SearchOption sharedSearchOption].departCityName;
    self.toCity.text = [SearchOption sharedSearchOption].arriveCityName;
    self.takeOffTime.text = [NSString stringFormatWithDate:[SearchOption sharedSearchOption].takeOffDate];
}

- (void)synchronizeSaveSearchOption
{
    [SearchOption sharedSearchOption].departCityName = self.fromCity.text;
    [SearchOption sharedSearchOption].arriveCityName = self.toCity.text;
    [SearchOption sharedSearchOption].takeOffDate = [NSString dateFormatWithString:self.takeOffTime.text];
}

#pragma mark - 选项gesture

- (void)optionLabelTapped:(UITapGestureRecognizer *)sender
{
    UILabel *label = (UILabel *)sender.view;

    
    if (label == self.fromCity) {
        CitySelectViewController *citiesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CitySelectViewConrtoller"];
        citiesViewController.delegate = self;
        citiesViewController.selectCityType = From_City;
        
        [self presentViewController:citiesViewController animated:YES completion:nil];
    } else if (label == self.toCity) {
        CitySelectViewController *citiesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CitySelectViewConrtoller"];
        citiesViewController.delegate = self;
        citiesViewController.selectCityType = To_City;
        
        [self presentViewController:citiesViewController animated:YES completion:nil];
    } else if (label == self.takeOffTime) {
        DateSelectViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelectViewController"];
        
        dateViewController.selectedDate = [NSString dateFormatWithString:self.takeOffTime.text];
        dateViewController.delegate = self;
        [self presentViewController:dateViewController animated:YES completion:nil];
    }
}

#pragma mark - delegate

- (void)setFromCityLabel:(NSString *)fromCityString
{
    self.fromCity.text = fromCityString;
}

- (void)setToCityLabel:(NSString *)toCityString
{
    self.toCity.text = toCityString;
}

- (void)setTakeOffTimeLabel:(NSDate *)takeOffTime
{
    self.takeOffTime.text = [NSString stringFormatWithDate:takeOffTime];
}

#pragma mark - Button Click event

- (IBAction)searchTicket:(id)sender
{
    
}

- (IBAction)moreOptionClicked:(id)sender
{
    NSLog(@"Show More Option");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        SearchResultViewController *vc = [segue destinationViewController];
        
        NSMutableDictionary *optionDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.fromCity.text, FROM_CITY_KEY, self.toCity.text, TO_CITY_KEY, self.takeOffTime.text, TAKE_OFF_TIME_KEY, nil];
        vc.searchOptionDic = optionDic;
    }
}

@end
