//
//  SearchResultViewController.m
//  TiCheck
//
//  Created by 邱峰 on 14-4-3.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "SearchResultViewController.h"
#import "LineChart.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,LineChartDataSource>

@property (weak, nonatomic) IBOutlet UILabel *searchResultTitle;

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (nonatomic,strong) NSArray* data;

@property (weak, nonatomic) IBOutlet UIButton *foldPriceButton;
@property (weak, nonatomic) IBOutlet UIButton *showPriceButton;
@property (weak, nonatomic) IBOutlet UIScrollView *lineChartParentView;

@property (nonatomic,strong) LineChart* lineChart;

@end

@implementation SearchResultViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 10;
    //return self.data.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier=@"SearchResultCell";
   
    
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    return cell;
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

#pragma mark - lineChart delegate

-(NSMutableArray*) setFooterLabel
{
    return [[NSMutableArray alloc] initWithObjects:@(8),@(9),@(10),@(11),@(12),@(13),@(14),nil];
}

-(NSMutableArray*) setScoreArray
{
    return [[NSMutableArray alloc] initWithObjects:@(702),@(425),@(329),@(568),@(749),@(693),@(551),nil];
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
    return 4;
}

@end
