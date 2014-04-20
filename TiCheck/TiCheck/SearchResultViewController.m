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
#import "SoapRequest.h"
#import "OTAFlightSearch.h"
#import "OTAFlightSearchResponse.h"
#import "APIResourceHelper.h"
#import "ConfigurationHelper.h"

#import "NSDate-Utilities.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"

#import "DomesticCity.h"
#import "Flight.h"
#import "CraftType.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,LineChartDataSource,EGORefreshTableHeaderDelegate,ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *searchResultTitle;

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (nonatomic,strong) NSArray* data;

@property (weak, nonatomic) IBOutlet UIButton *foldPriceButton;
@property (weak, nonatomic) IBOutlet UIButton *showPriceButton;
@property (weak, nonatomic) IBOutlet UIScrollView *lineChartParentView;

@property (nonatomic,strong) LineChart* lineChart;

@end

@implementation SearchResultViewController
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    ASIHTTPRequest *asiSearchRequest;
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
        [self sendFlightSearchRequest];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [asiSearchRequest cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchFlight Helper

- (void)sendFlightSearchRequest
{
    DomesticCity *depart = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:self.searchOptionDic[FROM_CITY_KEY]];
    DomesticCity *arrive = [[APIResourceHelper sharedResourceHelper] findDomesticCityViaName:self.searchOptionDic[TO_CITY_KEY]];
    NSDate *departDate = [NSString dateFormatWithString:self.searchOptionDic[TAKE_OFF_TIME_KEY]];
    
    OTAFlightSearch *searchRequets = [[OTAFlightSearch alloc] initOneWayWithDepartCity:depart
                                                                            arriveCity:arrive
                                                                            departDate:departDate];
    NSString *requestXML = [searchRequets generateOTAFlightSearchXMLRequest];
    
    asiSearchRequest = [SoapRequest getASISoap12RequestWithURL:API_URL
                                             flightRequestType:FlightSearchRequest
                                                  xmlNameSpace:XML_NAME_SPACE
                                                webServiceName:WEB_SERVICE_NAME
                                                xmlRequestBody:requestXML];
    [asiSearchRequest setDelegate:self];
    [asiSearchRequest startAsynchronous];
}

#pragma mark - ASIHTTPRequest Delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSLog(@"response = %@", [request responseString]);
    
    OTAFlightSearchResponse *response = [[OTAFlightSearchResponse alloc] initWithOTAFlightSearchResponse:[request responseString]];
    // 无搜索结果
    if (response.recordCount == 0) {
        
    } else {
        self.data = response.flightsList;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    // 搜索失败，网络问题
    NSLog(@"request failedddddddd. error = %@", [request error]);
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

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.resultTableView];
	
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
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
    return [[NSMutableArray alloc] initWithObjects:@(8),@(9),@(10),@(11),@(12),@(13),@(14),nil];
}

-(NSMutableArray*) setScoreArray
{
    return [[NSMutableArray alloc] initWithObjects:@(123),@(425),@(329),@(568),@(749),@(693),@(551),nil];
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
    return 2;
}

@end
