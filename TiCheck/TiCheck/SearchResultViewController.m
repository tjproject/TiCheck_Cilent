//
//  SearchResultViewController.m
//  TiCheck
//
//  Created by 邱峰 on 14-4-3.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "SearchResultViewController.h"
#import "LineChart.h"
#import "EGORefreshTableHeaderView.h"
#import "SearchResultCell.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "SoapRequest.h"
#import "OTAFlightSearch.h"
#import "OTAFlightSearchResponse.h"
#import "APIResourceHelper.h"
#import "ConfigurationHelper.h"
#import "TickectInfoViewController.h"

#import "NSDate-Utilities.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"

#import "DomesticCity.h"
#import "Flight.h"
#import "CraftType.h"
#import "Airline.h"
#import "Airport.h"

#define IS_RELOADING_FLAG @"IsReloading"
#define IS_SEARCH_DATE_USER_INFO_KEY @"IsSearchDate"
#define SEARCH_DATE_USER_INFO_KEY @"SearchData"
#define LONGEST_HISTORY_DAYS 7

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,LineChartDataSource,EGORefreshTableHeaderDelegate,ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *searchResultTitle;

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (nonatomic,strong) NSArray* data;

@property (weak, nonatomic) IBOutlet UIButton *foldPriceButton;
@property (weak, nonatomic) IBOutlet UIButton *showPriceButton;
@property (weak, nonatomic) IBOutlet UIScrollView *lineChartParentView;

@property (nonatomic,strong) LineChart* lineChart;

@property (strong, nonatomic) NSMutableDictionary *footIndexAndLowPrice;
@property (strong, nonatomic) NSMutableArray *footIndex;
@property (strong, nonatomic) NSMutableArray *footLowPrice;

@end

@implementation SearchResultViewController
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    ASIHTTPRequest *asiSearchRequest; // 选择搜索的
    ASINetworkQueue *asiSearchQueue; // 用户显示价格趋势的
    NSInteger currentIndex; // lineChart中显示当天
}

@synthesize data=_data;

static float tableViewHeight;
static float scrollViewHeight=169;

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
    [self setExtraCellLineHidden:self.resultTableView];
    currentIndex = 0;
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.resultTableView.bounds.size.height, self.view.frame.size.width, self.resultTableView.bounds.size.height)];
		view.delegate = self;
		[self.resultTableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.data count] == 0) {
        [self sendFlightSearchRequestWithReloading:NO];
        self.searchResultTitle.attributedText = [self resultTitleAttributedStringWithResultCount:-1];
    }
    
    if ([self.footIndexAndLowPrice count] != LONGEST_HISTORY_DAYS) {
        [self.showPriceButton setUserInteractionEnabled:NO];
        // 发送价格趋势的请求
        [self sendLowPriceTraceRequest];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [asiSearchRequest cancel];
    [asiSearchQueue cancelAllOperations];
    if ([self.footIndexAndLowPrice count] != LONGEST_HISTORY_DAYS) {
        self.footIndexAndLowPrice = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchFlight Helper

- (void)sendFlightSearchRequestWithReloading:(BOOL)isReloading
{
    DomesticCity *depart = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:self.searchOptionDic[FROM_CITY_KEY]];
    DomesticCity *arrive = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:self.searchOptionDic[TO_CITY_KEY]];
    NSDate *departDate = [NSString dateFormatWithString:self.searchOptionDic[TAKE_OFF_TIME_KEY]];
    
    OTAFlightSearch *searchRequets = [[OTAFlightSearch alloc] initOneWayWithDepartCity:depart
                                                                            arriveCity:arrive
                                                                            departDate:departDate];
    // 有ShowMore的选项
    if ([self.searchOptionDic[HAS_MORE_OPTION_KEY] boolValue]) {
        Airline *selectedAirline = [[APIResourceHelper sharedResourceHelper] findAirlineViaAirlineShortName:self.searchOptionDic[AIRLINE_KEY]];
        Airport *selectedAirport = [[APIResourceHelper sharedResourceHelper] findAirportViaName:self.searchOptionDic[DEPART_AIRPORT_KEY]];
        NSArray *selectedTakeOffTimeInterval = [self.searchOptionDic[TAKE_OFF_TIME_INTERVAL_KEY] componentsSeparatedByString:@" "];
        if (selectedAirline != nil) searchRequets.airline = selectedAirline.airline;
        searchRequets.classGrade = [NSString classGradeFromChineseString:self.searchOptionDic[SEAT_TYPE_KEY]];
        if (selectedAirport != nil) searchRequets.departPort = selectedAirport.airportCode;
        if ([selectedTakeOffTimeInterval count] == 3) {
            searchRequets.earliestDepartTime = [NSString timeFormatWithString:[NSString stringWithFormat:@"%@T%@:00", self.searchOptionDic[TAKE_OFF_TIME_KEY], selectedTakeOffTimeInterval[0]]];
            searchRequets.latestDepartTime = [NSString timeFormatWithString:[NSString stringWithFormat:@"%@T%@:00", self.searchOptionDic[TAKE_OFF_TIME_KEY], selectedTakeOffTimeInterval[2]]];
        }
    }
    NSString *requestXML = [searchRequets generateOTAFlightSearchXMLRequest];
    
    asiSearchRequest = [SoapRequest getASISoap12RequestWithURL:API_URL
                                             flightRequestType:FlightSearchRequest
                                                  xmlNameSpace:XML_NAME_SPACE
                                                webServiceName:WEB_SERVICE_NAME
                                                xmlRequestBody:requestXML];
    NSDictionary *mainUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(YES), IS_SEARCH_DATE_USER_INFO_KEY, @(isReloading), IS_RELOADING_FLAG, departDate, SEARCH_DATE_USER_INFO_KEY, nil];
    
    [asiSearchRequest setUserInfo:mainUserInfo];
    [asiSearchRequest setDelegate:self];
    [asiSearchRequest startAsynchronous];
}

- (void)sendLowPriceTraceRequest
{
    NSDate *departDate = [NSString dateFormatWithString:self.searchOptionDic[TAKE_OFF_TIME_KEY]];

    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.month = 5;
    NSDate *lastDate = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    
    // 在价格走势中要查看的价格日期范围
    NSMutableArray *toSearchDateArray = [NSMutableArray array];
    if ([departDate daysAfterDate:[NSDate date]] < 2) {
        for (NSInteger i = 0; i < 7; ++i) {
            NSDate *toSearchDate = [NSDate dateWithDaysFromNow:i];
            [toSearchDateArray addObject:toSearchDate];
            if ([toSearchDate isEqualToDateIgnoringTime:departDate]) {
                currentIndex = i;
            }
//            NSLog(@"%@", toSearchDateArray[i]);
        }
    } else if ([departDate daysBeforeDate:lastDate] < 5) {
        for (NSInteger i = 0; i < 7; ++i) {
            NSDate *toSearchDate = [lastDate dateBySubtractingDays:i];
            [toSearchDateArray addObject:toSearchDate];
            if ([toSearchDate isEqualToDateIgnoringTime:departDate]) {
                currentIndex = LONGEST_HISTORY_DAYS - i - 1;
            }
//            NSLog(@"%@", toSearchDateArray[i]);
        }
        toSearchDateArray = [NSMutableArray arrayWithArray:[[toSearchDateArray reverseObjectEnumerator] allObjects]];
    } else {
        NSDate *beginDate = [departDate dateBySubtractingDays:2];
        for (NSInteger i = 0; i < 7; ++i) {
            [toSearchDateArray addObject:[beginDate dateByAddingDays:i]];
//            NSLog(@"%@", toSearchDateArray[i]);
        }
        currentIndex = 2;
    }
    
    if (!asiSearchQueue) {
        asiSearchQueue = [[ASINetworkQueue alloc] init];
    }
    
    for (NSDate *toSearchDate in toSearchDateArray) {
        DomesticCity *depart = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:self.searchOptionDic[FROM_CITY_KEY]];
        DomesticCity *arrive = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:self.searchOptionDic[TO_CITY_KEY]];
        OTAFlightSearch *flightSearchRequest = [[OTAFlightSearch alloc] initOneWayWithDepartCity:depart
                                                                                      arriveCity:arrive
                                                                                      departDate:toSearchDate];
        NSString *flightSearchRequestXML = [flightSearchRequest generateOTAFlightSearchXMLRequest];
        
        ASIHTTPRequest *searchRequest = [SoapRequest getASISoap12RequestWithURL:API_URL
                                                              flightRequestType:FlightSearchRequest
                                                                   xmlNameSpace:XML_NAME_SPACE
                                                                 webServiceName:WEB_SERVICE_NAME
                                                                 xmlRequestBody:flightSearchRequestXML];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(NO), IS_SEARCH_DATE_USER_INFO_KEY, toSearchDate, SEARCH_DATE_USER_INFO_KEY, nil];
        searchRequest.delegate = self;
        searchRequest.userInfo = userInfo;
        
        [asiSearchQueue addOperation:searchRequest];
    }
    
    [asiSearchQueue go];
}

#pragma mark - ASIHTTPRequest Delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    OTAFlightSearchResponse *response = [[OTAFlightSearchResponse alloc] initWithOTAFlightSearchResponse:[request responseString]];
    
    if ([request.userInfo[IS_SEARCH_DATE_USER_INFO_KEY] boolValue]) {
        // 无搜索结果
        if (response.recordCount == 0) {
        } else {
            self.data = response.flightsList;
        }
        
        // 更新搜索结果Title，价格走势可用
        self.searchResultTitle.attributedText = [self resultTitleAttributedStringWithResultCount:[response.flightsList count]];
        
        if ([request.userInfo[IS_RELOADING_FLAG] boolValue]) {
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.resultTableView];
            _reloading = NO;
        }
        
        NSLog(@"搜索结果 finished");
    } else {
        NSDate *searchedDate = request.userInfo[SEARCH_DATE_USER_INFO_KEY];
        NSString *searchedStringKey = [NSString stringWithFormat:@"%lf", [searchedDate timeIntervalSince1970]];

        if (response.recordCount == 0) {
            [self.footIndex addObject:searchedStringKey];
            [self.footLowPrice addObject:@(0)];
            [self.footIndexAndLowPrice setObject:@(0) forKey:searchedStringKey];
        } else {
            Flight *lowestPriceFlight = [response.flightsList firstObject];
            [self.footIndex addObject:searchedStringKey];
            [self.footLowPrice addObject:@(lowestPriceFlight.price)];
            [self.footIndexAndLowPrice setObject:@(lowestPriceFlight.price) forKey:searchedStringKey];
        }
        
        if ([self.footIndexAndLowPrice count] == LONGEST_HISTORY_DAYS) {
            NSMutableArray *sortedDateKeys = [[self.footIndexAndLowPrice.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
            NSMutableArray *sortedValues = [NSMutableArray array];
            for (NSString *key in sortedDateKeys) {
                [sortedValues addObject: [self.footIndexAndLowPrice objectForKey:key]];
            }
            self.footIndex = sortedDateKeys;
            self.footLowPrice = sortedValues;
            
            [self.lineChart resetLineChartData];
            [self.showPriceButton setUserInteractionEnabled:YES];
            NSLog(@"价格趋势 finished");
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    // 搜索失败，网络问题
    NSLog(@"请求失败. error = %@", [request error]);
    NSError *error = [request error];
//    self.showPriceButton.userInteractionEnabled = YES;
    
    if (error.code == 2 && request.userInfo[IS_SEARCH_DATE_USER_INFO_KEY]) {
//        [asiSearchRequest cancel];
//        self.data = nil;
//        [self sendFlightSearchRequest];
    } else if (error.code == 2 && !request.userInfo[IS_SEARCH_DATE_USER_INFO_KEY]) {
//        [asiSearchQueue cancelAllOperations];
//        self.footIndexAndLowPrice = nil;
//        self.footIndex = nil;
//        self.footLowPrice = nil;
//        [self sendLowPriceTraceRequest];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self foldPrice:self.foldPriceButton];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(void) setResultTableView:(UITableView *)resultTableView
{
    if (_resultTableView==nil)
    {
        _resultTableView=resultTableView;
        tableViewHeight=_resultTableView.frame.size.height;
    }
}

-(void) setData:(NSArray *)data
{
    if (data!=_data)
    {
        _data=data;
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.resultTableView reloadData];
        });
    }
}

-(NSArray*) data
{
    if (_data==nil)
    {
        _data=[[NSArray alloc] init];
    }
    return _data;
}

- (NSMutableDictionary *)footIndexAndLowPrice
{
    if (_footIndexAndLowPrice == nil) {
        _footIndexAndLowPrice = [[NSMutableDictionary alloc] init];
    }
    return _footIndexAndLowPrice;
}

- (NSMutableArray *)footIndex
{
    if (_footIndex == nil) {
        _footIndex = [[NSMutableArray alloc] init];
    }
    return _footIndex;
}

- (NSMutableArray *)footLowPrice
{
    if (_footLowPrice == nil) {
        _footLowPrice = [[NSMutableArray alloc] init];
    }
    return _footLowPrice;
}

#pragma mark - tableview

/**
 *  去除多于的横线
 *
 *  @param tableView 需要添加的tableview
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 10;
    return self.data.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier=@"SearchResultCell";
   
    Flight *flight = self.data[indexPath.row];
    SearchResultCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                           forIndexPath:indexPath];
    [self updateSearchResultCellViaFlightInfo:flight
                                      forCell:cell];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TickectInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TicketInfoViewConyroller"];
    vc.selectFlight = [self.data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helper Methods

- (void)updateSearchResultCellViaFlightInfo:(Flight *)flight
                                    forCell:(SearchResultCell *)toUpdateCell
{
    toUpdateCell.startTime.text = [NSString showingStringFormatWithString:flight.takeOffTime];
    toUpdateCell.endTime.text = [NSString showingStringFormatWithString:flight.arrivalTime];
    toUpdateCell.address.text = [NSString stringWithFormat:@"%@——%@", flight.departPortShortName, flight.arrivePortShortName];
    toUpdateCell.flightNumber.text = flight.flightNumber;
    toUpdateCell.price.text = [NSString stringWithFormat:@"￥%ld", flight.price];
    if (flight.rate == 1.0f) {
        toUpdateCell.discount.text = @"全价";
    } else {
        toUpdateCell.discount.text = [NSString stringWithFormat:@"%.1f折", flight.rate * 10];
    }
    toUpdateCell.priceType.text = [NSString classGradeToChinese:flight.classGrade];
    toUpdateCell.remain.text = flight.quantity < 10 ? @"票少" : @"有余票";
    toUpdateCell.remain.textColor = flight.quantity < 10 ? [UIColor colorWithRed:0.984314 green:0.058824 blue:0.109804 alpha:1.0] : [UIColor colorWithRed:0.125490 green:0.639216 blue:0.866667 alpha:1.0];
    
    CraftType *ct = [[APIResourceHelper sharedResourceHelper] findCraftTypeViaCT:flight.craftType];
    if (ct == nil) {
        toUpdateCell.flighModel.text = @"未知";
    } else {
        toUpdateCell.flighModel.text = [ct craftKindShowingOnResult];
    }
}

- (NSAttributedString *)resultTitleAttributedStringWithResultCount:(NSInteger)resultCount
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@""];
    NSString *takeOffDateStr = self.searchOptionDic[TAKE_OFF_TIME_KEY];
    NSArray *takeOffDateArray = [takeOffDateStr componentsSeparatedByString:@"-"];
    NSInteger month = [takeOffDateArray[1] integerValue];
    NSInteger day = [takeOffDateArray[2] integerValue];
    
    NSDictionary *attributesForOriginalString = @{
                                                  NSFontAttributeName               : [UIFont systemFontOfSize:17],
                                                  NSForegroundColorAttributeName    : [UIColor colorWithRed:0.117647 green:0.701961 blue:0.894118 alpha:1.0],
                                                  NSBackgroundColorAttributeName    : [UIColor clearColor]
                                                  };
    NSDictionary *attributesForNumberString   = @{
                                                  NSFontAttributeName               : [UIFont boldSystemFontOfSize:26],
                                                  NSForegroundColorAttributeName    : [UIColor colorWithRed:0.670588 green:0.815686 blue:0.376471 alpha:1.0],
                                                  NSBackgroundColorAttributeName    : [UIColor clearColor],
                                                  NSBaselineOffsetAttributeName     : @(-2.0f),
                                                  };
    
    // 传入resultCount为-1时表示正在搜索中
    if (resultCount == -1) {
        NSString *searching = [NSString stringWithFormat:@"正在为您搜索机票中..."];
        result = [[NSMutableAttributedString alloc] initWithString:searching
                                                        attributes:attributesForOriginalString];
    } else if (resultCount == 0) {
        NSString *noResult = [NSString stringWithFormat:@"%ld月%ld日没有合适的机票", month, day];
        result = [[NSMutableAttributedString alloc] initWithString:noResult
                                                        attributes:attributesForOriginalString];
    } else {
        NSString *beforeResult = [NSString stringWithFormat:@"为您在%ld月%ld日找到", month, day];
        NSString *number = [NSString stringWithFormat:@"%ld", resultCount];
        NSString *afterResult = [NSString stringWithFormat:@"张低价票"];
        NSString *wholeResult = [NSString stringWithFormat:@"%@%@%@", beforeResult, number, afterResult];
        
        result = [[NSMutableAttributedString alloc] initWithString:wholeResult];
        
        [result setAttributes:attributesForOriginalString
                        range:[wholeResult rangeOfString:beforeResult]];
        [result setAttributes:attributesForNumberString
                        range:[wholeResult rangeOfString:number]];
        [result setAttributes:attributesForOriginalString
                        range:[wholeResult rangeOfString:afterResult]];
    }
    
    return result;
}

#pragma mark - show button

- (IBAction)foldPrice:(id)sender
{
    @synchronized(self){
        if (self.showPriceButton.hidden==NO) return  ;
        self.showPriceButton.hidden=NO;
        self.foldPriceButton.hidden=YES;
        self.resultTableView.frame=CGRectMake(self.resultTableView.frame.origin.x, self.resultTableView.frame.origin.y, self.resultTableView.frame.size.width, tableViewHeight);
    }
}

- (IBAction)showPrice:(UIButton *)sender
{
    @synchronized(self){
        if (self.foldPriceButton.hidden==NO) return ;
        self.foldPriceButton.hidden=NO;
        self.showPriceButton.hidden=YES;
        self.resultTableView.frame=CGRectMake(self.resultTableView.frame.origin.x, self.resultTableView.frame.origin.y, self.resultTableView.frame.size.width, tableViewHeight-scrollViewHeight);
        [self.lineChart resetLineChartData];
    }
}


#pragma mark - EGORefreshTableHeaderDelegate


#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    [self sendFlightSearchRequestWithReloading:YES];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - lineChart delegate

-(NSMutableArray*) setFooterLabel
{
    NSMutableArray *footLabelIndexResult = [NSMutableArray array];
//    
//    NSArray *keyArray = [[self.footIndexAndLowPrice.keyEnumerator allObjects] mutableCopy];
//    
    for (NSString *dateKey in self.footIndex) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateKey doubleValue]];
        NSString *dateString = [NSString stringFormatWithDate:date];
        NSArray *seperateDate = [dateString componentsSeparatedByString:@"-"];
        
        [footLabelIndexResult addObject:@([seperateDate[2] integerValue])];
        
//        NSLog(@"date = %@, price = %@", dateString, self.footIndexAndLowPrice[dateKey]);
    }
    
    return footLabelIndexResult;
}

-(NSMutableArray*) setScoreArray
{
    NSMutableArray *footLabelPriceResult = [NSMutableArray array];
    
//    NSArray *valueArray = [[self.footIndexAndLowPrice.objectEnumerator allObjects] mutableCopy];
    
    for (NSNumber *value in self.footLowPrice) {
        [footLabelPriceResult addObject:value];
    }
    
    return footLabelPriceResult;
}

-(void) setLineChart:(LineChart *)lineChart
{
    if (_lineChart!=lineChart)
    {
        _lineChart=lineChart;
        _lineChart.lineChartDataSource=self;
        _lineChart.isNeedToDraw=YES;
    }
}

-(void) setLineChartParentView:(UIScrollView *)lineChartParentView
{
    if (_lineChartParentView!=lineChartParentView)
    {
        _lineChartParentView=lineChartParentView;
        
        self.lineChart=[[LineChart alloc] init];
        self.lineChart.parentView=_lineChartParentView;
        [self.lineChart initLineChartMemberData];
        [self.lineChartParentView addSubview:self.lineChart];
        [self.lineChart setNeedsDisplay];
    }
}

-(BOOL) setIsNeedFill
{
    return YES;
}

-(UIColor*) setFillColor
{
    return [UIColor colorWithRed:244/255.0 green:255/255.0 blue:221/255.0 alpha:1];
}

-(float) setPointRadius
{
    return 3;
}

-(UIColor*) setLineColor
{
    return [UIColor colorWithRed:170/255.0 green:210/255.0 blue:89/255.0 alpha:1];
}

-(int) setCurrentIndex
{
//    NSLog(@"current day index = %ld", (long)currentIndex);
    return currentIndex;
}

@end
