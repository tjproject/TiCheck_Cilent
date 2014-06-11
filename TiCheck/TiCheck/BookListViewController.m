//
//  BookListViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-21.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "BookListViewController.h"
#import "PersonalOrderTableViewCell.h"
#import "TickectInfoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "SoapRequest.h"

#import "ConfigurationHelper.h"
#import "NSDate-Utilities.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"
#import "DomesticCity.h"
#import "Flight.h"
#import "CraftType.h"
#import "Airline.h"
#import "Airport.h"
#import "Passenger.h"
#import "Contact.h"
#import "CreditCardInfo.h"
#import "UserData.h"

#import "ConfigurationHelper.h"
#import "ServerCommunicator.h"

#import "Subscription.h"
#import "ServerRequest.h"

#import "OTAFlightSearchResponse.h"

#import "APIResourceHelper.h"

#import "AppDelegate.h"

extern NSDictionary *notificationOption;

#define SECTION_BUTTON_TAG_START_INDEX 1000
#define EXPAND_BUTTON_TAG_START_INDEX 2000
#define DEFAULT_CELL_NUM 3


@interface BookListViewController ()
{
    NSMutableArray* bookOrderList;
    
    NSMutableArray* isCellExpanded;
    
    NSMutableArray* sectionViewList;
}
@end

@implementation BookListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self initSubscriptionInfoData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    self.navigationItem.title=@"我的订阅";
    
    //[self initDataCount];
    [self initSubscriptionInfoData] ;//]:self.returnDic];
    //[self initBookOrderList];
    
    [self setExtraCellLineHidden:self.bookListTableView];

}

//delete useless lines
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (notificationOption != nil)
    {
        NSLog(@"book list view controller do something here to deal with notification");
        
        NSInteger subsId = [notificationOption[@"ID"] integerValue];
        NSUInteger sectionId;
        notificationOption = nil;
        NSLog(@"%d", subsId);
        
        for (Subscription *subs in self.subscriptionArray) {
            if ([subs.ID integerValue] == subsId) {
                NSLog(@"find the subscription");
                sectionId = [self.subscriptionArray indexOfObject:subs];
                NSLog(@"%d", sectionId);
                NSIndexPath *toChangedCell;
                if ([[self.flightListArray objectAtIndex:sectionId] count] == 0)
                {
                    toChangedCell = [NSIndexPath indexPathForRow:NSNotFound inSection:sectionId];
                }
                else {
                    toChangedCell = [NSIndexPath indexPathForRow: 0 inSection:sectionId];
                }
                [self.bookListTableView scrollToRowAtIndexPath:toChangedCell  atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initDataCount
{
//    self.dataCount = 0;
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    if ([appDelegate.internetReachability currentReachabilityStatus] == NotReachable) {
//        return ;
//    }
//    if ([appDelegate.hostReachability currentReachabilityStatus] == NotReachable) {
//        return ;
//    }
//    //get subscription data for server
//    self.returnDic = [[ServerCommunicator sharedCommunicator] getSubscriptionInfo];
//    NSInteger returnCode = [self.returnDic[SERVER_RETURN_CODE_KEY] integerValue];
//    if (returnCode == USER_LOGIN_SUCCESS)
//    {
//        self.subscriptionArray = [[NSMutableArray alloc] init];
//        self.flightListArray = [[NSMutableArray alloc] init];
//        //get data
//        id stringArray = self.returnDic[@"Data"];
//        NSArray *dataArray;
//        if([stringArray isKindOfClass:[NSString class]])
//        {
//            //
//        }
//        else
//        {
//            dataArray = self.returnDic[@"Data"];
//            self.dataCount = dataArray.count;
//        }
//    }
}

- (void)initSubscriptionInfoData
{
    
    self.subscriptionArray = [[NSMutableArray alloc] init];
    self.flightListArray = [[NSMutableArray alloc] init];
    
    //get subscription data for server
    
    if(![[ConfigurationHelper sharedConfigurationHelper] isInternetConnection])
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请检查网络重新操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    else
    {
        if (![[ConfigurationHelper sharedConfigurationHelper] isServerHostConnection]) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"服务器维护中" message:@"服务器例行维护中，稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        else
        {
            
            NSDictionary *returnDic = [[ServerCommunicator sharedCommunicator] getSubscriptionInfo];
            NSInteger returnCode = [returnDic[SERVER_RETURN_CODE_KEY] integerValue];
            
            
            
            
            
            if (returnCode == USER_LOGIN_SUCCESS)
            {
                self.subscriptionArray = [[NSMutableArray alloc] init];
                self.flightListArray = [[NSMutableArray alloc] init];
                //get data
                id stringArray = returnDic[@"Data"];
                NSArray *dataArray;
                if([stringArray isKindOfClass:[NSString class]])
                {
                    //
                }
                else
                {
                    dataArray = returnDic[@"Data"];
                    for(int i = 0; i < dataArray.count; i++)
                    {
                        NSDictionary *tempDictionary = [dataArray objectAtIndex:i];
                        NSDictionary *tempSubscriptionDictionary = tempDictionary[@"Subscription"];
                        
                        //TODO: change dictionary data to subscription entity stored in subscriptionArray.
                        //      research flight by using subscription info and display them in table view
                        //      add edit function for subscription
                        
                        NSString *id_string = [tempSubscriptionDictionary objectForKey:@"ID"];
                        NSLog(@"ID string: %@", id_string);
                        NSNumber *id_number = [[NSNumber alloc] initWithInteger:[id_string integerValue]];
                        Subscription *tempSubscription = [[Subscription alloc] initWithDepartCityCode:tempSubscriptionDictionary[@"DepartCity"]
                                                                                       arriveCityCode:tempSubscriptionDictionary[@"ArriveCity"]
                                                                                            startDate:tempSubscriptionDictionary[@"StartDate"]
                                                                                              endDate:tempSubscriptionDictionary[@"EndDate"]
                                                                                             idNumber:id_number];
                        
                        [self.subscriptionArray addObject:tempSubscription];
                        
                        NSMutableArray *allFlightListOfOneSubscirption = [[NSMutableArray alloc] init];
                        
                        NSString *header = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><RequestResponse xmlns=\"http://ctrip.com/\"><RequestResult>";
                        NSString *footer = @"</RequestResult></RequestResponse></soap:Body></soap:Envelope>";
                        //NSString *filghtXML = [[dataArray objectAtIndex:0][@"FlightXML"] objectAtIndex:0][@"FlightXML"];
                        
                        if([tempDictionary[@"FlightXML"] isKindOfClass:[NSNull class]])
                        {
                            [self.flightListArray addObject:allFlightListOfOneSubscirption];
                            //continue;
                        }
                        else
                        {
                            NSArray *tempFlightXMLDictionaryList = tempDictionary[@"FlightXML"];
                            for (NSDictionary *d in tempFlightXMLDictionaryList) {
                                NSString *body = d[@"FlightXML"];
                                NSString *resultXML = [header stringByAppendingString: body ];
                                resultXML = [resultXML stringByAppendingString:footer];
                                OTAFlightSearchResponse *response = [[OTAFlightSearchResponse alloc] initWithOTAFlightSearchResponse:resultXML];
                                [allFlightListOfOneSubscirption addObjectsFromArray:response.flightsList];
                            }
                            
                            [self.flightListArray addObject:allFlightListOfOneSubscirption];
                        }
                    }
                    isCellExpanded=[[NSMutableArray alloc]init];
                    
                    for (int i=0; i<self.subscriptionArray.count; i++) {
                        [isCellExpanded addObject:[NSNumber numberWithInt:0]];
                    }
                }
            }
        }
    }
}

- (void)initBookOrderList
{
    bookOrderList=[[NSMutableArray alloc]init];
    isCellExpanded=[[NSMutableArray alloc]init];
    
    for(int i=0; i<self.subscriptionArray.count;i++)
    {
        NSMutableArray *temp=[[NSMutableArray alloc]init];
        
        for (int j=0; j<(i+1)*3; j++) {
            [temp addObject: [NSString stringWithFormat:@"%i",j ]];
        }
        
        [bookOrderList addObject:temp];
    }
    
    
    for (int i=0; i<bookOrderList.count; i++) {
        [isCellExpanded addObject:[NSNumber numberWithInt:0]];
    }
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.subscriptionArray.count;  //bookOrderList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionCount=((NSMutableArray*)[self.flightListArray objectAtIndex:section]).count;
    
    if(sectionCount <= DEFAULT_CELL_NUM)
    {
        return sectionCount;
    }
    else if([[isCellExpanded objectAtIndex:section] intValue]==1)
    {
        return sectionCount;
    }
    else
    {
        return DEFAULT_CELL_NUM;
    }
    
    //return [[isCellExpanded objectAtIndex:section] intValue]==1? sectionCount :3;//(sectionCount<=3?sectionCount:3);
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PersonalOrderCellIdentifier";
    PersonalOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[PersonalOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        //NSMutableArray *temp=[bookOrderList objectAtIndex:indexPath.section];
        //NSString *time=[NSString stringWithFormat:@"num: %i", [[temp objectAtIndex: indexPath.row] intValue]];
        
        NSMutableArray *tempFlightList = [self.flightListArray objectAtIndex:indexPath.section];
        Flight *tempFlight = [tempFlightList objectAtIndex:indexPath.row];
        CraftType *ct = [[APIResourceHelper sharedResourceHelper] findCraftTypeViaCT:tempFlight.craftType];
        NSString *flightModel;
        if (ct == nil) {
            flightModel = @"未知";
        } else {
            flightModel = [ct craftKindShowingOnResult];
        }
        
        [cell initOrderInfoWithFlight:[NSString stringWithFormat:@"%@%@",tempFlight.airlineShortName,tempFlight.flightNumber]
                                Plane:[NSString stringWithFormat:@"%@ %@",flightModel,[NSString classGradeToChinese:tempFlight.classGrade]]
                                 Time:[NSString stringWithFormat:@"%@  %@",
                                       [NSString stringFormatWithDate: tempFlight.takeOffTime],
                                       [NSString showingStringFormatWithString: tempFlight.takeOffTime]]
                                Place:[NSString stringWithFormat:@"%@ - %@", tempFlight.departCityName, tempFlight.arriveCityName]
                          FlightImage:[UIImage imageNamed:tempFlight.airlineDibitCode]];
    }
    
    
    //TODO: 根据前一天的价格趋势（或前一个时间段价格），相应显示上升或下降标示
    //
    //
    
//    if(indexPath.section>1)
//    {
//        cell.priceTrednImage.image = [UIImage imageNamed:@"PriceDown"];
//    }
//    else
//    {
//        cell.priceTrednImage.image = [UIImage imageNamed:@"PriceUp"];
//    }

    
    return cell;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TickectInfoViewController *tiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TickectInfoViewController"];
    
    tiVC.selectFlight = [[self.flightListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    tiVC.departureDate = ((Flight*)[[self.flightListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).takeOffTime;
    [self.navigationController pushViewController:tiVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //自定义section view
    //存储sectionView 使之不被重复创建
    if(sectionViewList==nil)
    {
        sectionViewList = [[NSMutableArray alloc]init];
    }
    
    if(section>=sectionViewList.count)
    {
        
        UIView* temp=[[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 39)];
        temp.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
        
        //add sectionbutton for book change
        UIButton* sectionButton=[UIButton buttonWithType:UIButtonTypeCustom];//initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 39)];
        [sectionButton setFrame:CGRectMake(0, 0, tableView.frame.size.width, 39)];
        
        //section title name
        NSString *title = [self getSectionTitleWithSubscription:[self.subscriptionArray objectAtIndex:section]];
        [sectionButton setTitle:title forState:UIControlStateNormal];
        
        
        
        [sectionButton setTitleColor:[UIColor colorWithRed:12/255.0 green:162/255.0 blue:224/255.0 alpha:1] forState:UIControlStateNormal];
        
        sectionButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12.f];
        [sectionButton addTarget:self action:@selector(sectionListButton:) forControlEvents:UIControlEventTouchUpInside];
        
        sectionButton.tag=section+SECTION_BUTTON_TAG_START_INDEX;
        
        [temp addSubview:sectionButton];
        
        if ( ((NSMutableArray*)[self.flightListArray objectAtIndex:section]).count>3) {
            
            //add expand button for expanding all ticket
            UIButton* expandButton=[UIButton buttonWithType:UIButtonTypeCustom];//initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 39)];
            [expandButton setFrame:CGRectMake(260, 0, 70, 39)];
            [expandButton setTitle:@"展开" forState:UIControlStateNormal];
            [expandButton setTitleColor:[UIColor colorWithRed:12/255.0 green:162/255.0 blue:224/255.0 alpha:1] forState:UIControlStateNormal];
            //[expandButton setTitleColor:[UIColor colorWithRed:44/255.0 green:33/255.0 blue:224/255.0 alpha:1] forState:UIControlStateHighlighted];
            [expandButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            expandButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.f];
            [expandButton addTarget:self action:@selector(expandButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
            
            expandButton.tag=section+EXPAND_BUTTON_TAG_START_INDEX;
            
            [temp addSubview:expandButton];
            [temp bringSubviewToFront:expandButton];
            
        }
        
        //add separator line
        UIView *separatorline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, temp.frame.size.width, 0.5 )];
        separatorline.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
        [temp addSubview:separatorline];
        
        UIView *separatorline2 = [[UIView alloc] initWithFrame:CGRectMake(0, temp.frame.size.height, temp.frame.size.width, 0.5 )];
        separatorline2.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
        [temp addSubview:separatorline2];
        
        
        [sectionViewList addObject:temp];
    }
    

    return [sectionViewList objectAtIndex:section];
}

- (void) sectionListButton:(id)sender
{
    //
    //NSLog(@"test section button");
    UIButton *temp=(UIButton*)sender;
    NSInteger buttonIndex=temp.tag-SECTION_BUTTON_TAG_START_INDEX;
    NSLog(@"section %d",buttonIndex);
}

- (void) expandButtonFunction:(id)sender
{
    UIButton *temp=(UIButton*)sender;
    NSInteger buttonIndex=temp.tag-EXPAND_BUTTON_TAG_START_INDEX;
    NSLog(@"button %d",buttonIndex);
    
    
    int result =([[isCellExpanded objectAtIndex:buttonIndex] intValue]+1)%2;
    //update state
    [isCellExpanded replaceObjectAtIndex:buttonIndex withObject:[NSNumber numberWithInt:result]];
    
    //bug:在收起cell时， 删除了不该删除的cell
    //animation
    NSMutableArray *changedCellIndexArray = [NSMutableArray array];
    for (NSInteger i = 0; i < (((NSMutableArray*)[self.flightListArray objectAtIndex:buttonIndex]).count-3 ); i++)
    {
        NSIndexPath *toChangedCell = [NSIndexPath indexPathForRow: 3+i inSection:buttonIndex];
        [changedCellIndexArray addObject:toChangedCell];
    }
    if(result==1)
    {
        [temp setTitle:@"收起" forState:UIControlStateNormal];
        //expand, add cells
        //[self.bookListTableView beginUpdates];
        [self.bookListTableView insertRowsAtIndexPaths:changedCellIndexArray withRowAnimation:UITableViewRowAnimationTop];
        //[self.bookListTableView endUpdates];
    }
    else if(result==0)
    {
        [temp setTitle:@"展开" forState:UIControlStateNormal];
        //unexpand, delete cells
        //[self.bookListTableView beginUpdates];
        [self.bookListTableView deleteRowsAtIndexPaths:changedCellIndexArray withRowAnimation:UITableViewRowAnimationTop];
        //[self.bookListTableView endUpdates];
    }
}

- (NSString*)getSectionTitleWithSubscription:(Subscription*) subscription
{
    //@"2013-04-13 至 2013-04-25 上海到北京"
    //格式化日期时间
    if (subscription!=nil)
    {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *result = [dateformatter stringFromDate:subscription.startDate];
        result = [result stringByAppendingString:[NSString stringWithFormat:@" 至 %@ ", [dateformatter stringFromDate:subscription.endDate]]];
    
        NSString *cityStr = subscription.departCity.cityName;
        cityStr = [cityStr stringByAppendingString:[NSString stringWithFormat:@"到%@", subscription.arriveCity.cityName]];
    
        result = [result stringByAppendingString:cityStr];
        return result;
    }
    else
    {
        return nil;
    }
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
