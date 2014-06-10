//
//  PayProcessViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-16.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PayProcessViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "SoapRequest.h"
#import "OTAFlightSaveOrder.h"
#import "OTAFlightSaveOrderResponse.h"
#import "APIResourceHelper.h"
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

#import "ServerRequest.h"

#import "OTAUserUniqueID.h"
#import "OTAUserUniqueIDResponse.h"

#import "OTAFlightOrderList.h"
#import "OTAFlightOrderListResponse.h"

#import "OTAFlightViewOrder.h"
#import "OTAFlightViewOrderResponse.h"

#import "OnlinePayViewController.h"
#define PAY_REQUEST_TYPE @"PaymentEntry.aspx"

@interface PayProcessViewController ()<ASIHTTPRequestDelegate>

@end

@implementation PayProcessViewController
{
    OTAFlightSaveOrder *flightOrderRequest;
    
    ASIHTTPRequest *asiFlightOrderRequest; //
    ASIHTTPRequest *asiUniqueIDRequest; //
    ASIHTTPRequest *asiOrderListRequest;
    ASIHTTPRequest *asiOrderViewRequest;
    
    ASIFormDataRequest *asiFlightPayDataRequest;
    NSString *orderID;
    //ASINetworkQueue *asiSearchQueue; //
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
    
    [self initFlightOrder];
    [self initInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initFlightOrder
{
    //添加机票订购信息
    //NSArray *flightList = [NSArray arrayWithObjects:self.selectFlight, nil];
    
    //预先设置 乘客
//    NSDateComponents *comp = [[NSDateComponents alloc]init];
//    [comp setMonth:9];
//    [comp setDay:22];
//    [comp setYear:1991];
//    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDate *bDate = [myCal dateFromComponents:comp];
//    
//    Passenger *tempPassenger = [Passenger passengerWithPassengerName:@"黄泽彪" birthday:bDate  passportType:ID passportNo:@"440508199109223314" isTemporary:YES];
//    tempPassenger.gender = [NSNumber numberWithInteger:Male];
//    tempPassenger.nationalityCode = @"1";
//    tempPassenger.contactTelephone = @"18817598462";
//    
//    NSArray *pList = [NSArray arrayWithObjects:tempPassenger, nil];
//
////    //联系人
//    Contact *contact = [Contact contactWithContactName:@"黄泽彪" confirmOption:EML mobilePhone:tempPassenger.contactTelephone contactEmail: [UserData sharedUserData].email];
//
    
    //self.flightOrder.passengerList = pList;
    self.flightOrder.contact = ((Passenger *)[self.flightOrder.passengerList objectAtIndex:0]).contact;
    flightOrderRequest = self.flightOrder;
    
    self.selectFlight = [flightOrderRequest.flightInfoList objectAtIndex:0];
    self.passengerList = flightOrderRequest.passengerList;
    
    //生成请求
    //flightOrderRequest = [[OTAFlightSaveOrder alloc] initWithUserUniqueUID:[UserData sharedUserData].uniqueID AgeType:ADU flightList:flightOrderRequest.flightInfoList passengerList:flightOrderRequest.passengerList contact:flightOrderRequest.contact];
    [flightOrderRequest generateOTAFlightSaveOrderXMLRequest];
}

- (void)initInfo
{
    //flight name
    self.flightNameAndIDLabel.text = [self.selectFlight.airlineShortName stringByAppendingString:self.selectFlight.flightNumber];
    
    //time
    //格式化日期时间
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];//@"YYYY-MM-dd-HH-mm-ss
    NSDate *takeOffTime = self.selectFlight.takeOffTime;
    self.flightDateLabel.text = [dateformatter stringFromDate:takeOffTime];
    
    [dateformatter setDateFormat:@"HH-mm"];
    self.flightTimeLabel.text = [dateformatter stringFromDate:takeOffTime];
    
    //flight location
    self.flightLocationLabel.text = [self getFlightLocation:self.selectFlight.departCityName AndToLoaction:self.selectFlight.arriveCityName];
    
    //passenger
    //self.flightPassengerNameLabel.text = ((Passenger*)[self.passengerList objectAtIndex:0]).passengerName;
    self.flightPassengerNameLabel.text = ((Passenger*)[self.passengerList objectAtIndex:0]).passengerName;

    //price
    self.flightPriceLabel.text = [NSString stringWithFormat:@"%d",[self calculTotalPrice]];  //self.selectFlight.price;
    
    [self setFlightLogo:@""];
}


#pragma mark - set complex string for info display
- (NSString*)getFlightLocation:(NSString*)fromLocation AndToLoaction:(NSString*)toLocation
{
    //use two lacation to generate string like the formate: xxx 至 xxx
    //
    NSString *result=[fromLocation stringByAppendingString:@" 至 "];
    result=[result stringByAppendingString:toLocation];
    return result;
    
}

- (void)setFlightLogo:(NSString*) airlineName
{
    //get the image of airlineName;
    self.flightLogoImage.image=[UIImage imageNamed:self.selectFlight.airlineDibitCode];
    //or other function...
}

- (NSInteger)calculTotalPrice
{
    // TODO:
    // 考虑不同的乘客 不同的票价
    // 保险等因素
    //
    // ...
    //
    return (self.selectFlight.price + self.selectFlight.adultOilFee + self.selectFlight.adultTax)*self.passengerList.count;//flightOrderRequest.amount;//
}




#pragma mark - pay 
- (IBAction)confirmPayButton:(id)sender
{
//    NSLog(@"confirm,Pay");
//    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"支付中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
    
    
    //TODO: when clicked, jump to a web page to continue the pay process
    
    //get userid
    //[self sendUniqueIDRequest];
    
    //create temp flight order
    [self sendFlightSaveOrderRequest];
    
    //test order list
    //[self sendOrderListRequest];
    
    //get order view
    //[self sendOrderViewRequest];
    
}

- (void)sendOrderViewRequest
{
    
    OTAFlightViewOrder *orderViewRequest = [[OTAFlightViewOrder alloc] initWithUserUniqueUID:[UserData sharedUserData].uniqueID orderLists: [NSArray arrayWithObjects:orderID, nil]];
    
    
    NSString *requestXML = [orderViewRequest generateOTAFlightViewOrderXMLRequest];
    
    asiOrderViewRequest = [SoapRequest getASISoap12RequestWithURL:API_URL
                                                flightRequestType:FlightViewOrderRequest
                                                     xmlNameSpace:XML_NAME_SPACE
                                                   webServiceName:WEB_SERVICE_NAME
                                                   xmlRequestBody:requestXML];
    NSDictionary *mainUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"asiRequestType", nil];
    
    [asiOrderViewRequest setUserInfo:mainUserInfo];
    [asiOrderViewRequest setDelegate:self];
    [asiOrderViewRequest startAsynchronous];
}



- (void)sendOrderListRequest
{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:5];
    [comp setDay:9];
    [comp setYear:2014];
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *efDate = [myCal dateFromComponents:comp];
    
    [comp setMonth:6];
    [comp setDay:9];
    [comp setYear:2014];
    NSDate *exData = [myCal dateFromComponents:comp];
    
    OTAFlightOrderList *orderListRequest = [[OTAFlightOrderList alloc] initWithUserUniqueUID:[UserData sharedUserData].uniqueID effectDate:efDate expiryDate:exData orderStatus:AllOrders];
    
    
    NSString *requestXML = [orderListRequest generateOTAFlightOrderListXMLRequest];
    
    asiOrderListRequest = [SoapRequest getASISoap12RequestWithURL:API_URL
                                                  flightRequestType:FlightOrderListRequest
                                                       xmlNameSpace:XML_NAME_SPACE
                                                     webServiceName:WEB_SERVICE_NAME
                                                     xmlRequestBody:requestXML];
    NSDictionary *mainUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"asiRequestType", nil];
    
    [asiOrderListRequest setUserInfo:mainUserInfo];
    [asiOrderListRequest setDelegate:self];
    [asiOrderListRequest startAsynchronous];
}

- (void)sendUniqueIDRequest
{
    OTAUserUniqueID *idRequest = [[OTAUserUniqueID alloc] initWithUserName:[UserData sharedUserData].email telNumber:@""];
    NSString *requsetXML = [idRequest generateOTAUserUniqueIDXMLRequest];
    asiUniqueIDRequest = [SoapRequest getASISoap12RequestWithURL:API_URL
                                               flightRequestType:UserUniqueID
                                                    xmlNameSpace:XML_NAME_SPACE
                                                  webServiceName:WEB_SERVICE_NAME
                                                  xmlRequestBody:requsetXML];
    NSDictionary *mainUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"asiRequestType", nil];
    
    [asiUniqueIDRequest setUserInfo:mainUserInfo];
    [asiUniqueIDRequest setDelegate:self];
    [asiUniqueIDRequest startAsynchronous];
    //[asiUniqueIDRequest star]
}

#pragma mark - SearchFlight Helper

- (void)sendFlightSaveOrderRequest
{
    NSString *requestXML = [flightOrderRequest generateOTAFlightSaveOrderXMLRequest];
    
    asiFlightOrderRequest = [SoapRequest getASISoap12RequestWithURL:API_URL
                                             flightRequestType:FlightSaveOrderRequest
                                                  xmlNameSpace:XML_NAME_SPACE
                                                webServiceName:WEB_SERVICE_NAME
                                                xmlRequestBody:requestXML];
    //异步发送
    NSDictionary *mainUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"asiRequestType", nil];
    [asiFlightOrderRequest setUserInfo:mainUserInfo];
    [asiFlightOrderRequest setDelegate:self];
    [asiFlightOrderRequest startAsynchronous];
}

#pragma mark - flight pay Helper

- (void)sendFlightPayPost:(NSString *)orderID
{
    Order *tempOrder = [Order orderWithOrderId:orderID
                                   flightsList:flightOrderRequest.flightInfoList
                                passengersList:flightOrderRequest.passengerList
                                   orderStatus:Deal
                                   totalAmount:(self.selectFlight.price + self.selectFlight.adultOilFee + self.selectFlight.adultTax)//flightOrderRequest.amount
                                     insurance:30];
    
    //http://{API_Url}/{BusinessType}/MobilePayEntry.aspx?AllianceId={AllianceId}&SID={SID}&TimeStamp={TimeStamp}&Signature={Signature}&RequestType={RequestType}
    NSString *strURLTrail = [[ConfigurationHelper sharedConfigurationHelper] getURLStringWithRequestType:PaymentEntry];
    NSString *strURL = [NSString stringWithFormat:@"%@%@/mobilepayentry.aspx%@",API_URL,BUSINESS_TYPE,strURLTrail];
    NSURL *url = [NSURL URLWithString:strURL];
    OnlinePayViewController *opVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlinePayViewController"];
    opVC.departureDate = self.departureDate;
    opVC.url = url;
    opVC.flightOrder = tempOrder;
    [self.navigationController pushViewController:opVC animated:YES];
}

#pragma mark - ASIHTTPRequest Delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //获取user id
    if([request.userInfo[@"asiRequestType"] isEqualToString:@"0"])
    {
        OTAUserUniqueIDResponse *response = [[OTAUserUniqueIDResponse alloc] initWithOTAUserUniqueIDResponse:[request responseString]];
        if (response.retCode == 0) {
            NSLog(@"Unique ID = %@",response.uniqueUID);
            [UserData sharedUserData].uniqueID = response.uniqueUID;
        }
    }
    //订单支付请求
    else if([request.userInfo[@"asiRequestType"] isEqualToString:@"1"])
    {
        OTAFlightSaveOrderResponse *response = [[OTAFlightSaveOrderResponse alloc] initWithOTASaveOrderResponse:[request responseString]];
        
        if(response.result)
        {
            orderID = response.tempOrderID;
        
            NSLog(@"订单结果 = %@",response.resultMsg);
            NSLog(@"订单ID = %@",response.tempOrderID);

            //pay － 获取临时订单号后跳转支付页面
            [self sendFlightPayPost:response.tempOrderID];
        }
        else
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"支付失败" message:@"请重新支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    //订单列表查询请求 － 查找携程数据库
    else if([request.userInfo[@"asiRequestType"] isEqualToString:@"2"])
    {
        OTAFlightOrderListResponse *response = [[OTAFlightOrderListResponse alloc] initWithOTAFlightOrderListResponse:[request responseString]];
        NSLog(@"查询订单结果 = %i",response.recordsCount);
        
        //NSArray *temp=response.orderList;
    }
    //单张订单详情查询请求 － 查找携程数据库
    else if([request.userInfo[@"asiRequestType"] isEqualToString:@"3"])
    {
        //OTAFlightViewOrder *response = [[OTAFlightViewOrderResponse alloc] initWithOTAFlightViewOrderResponse:[request responseString]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    // 搜索失败，网络问题
    NSLog(@"订单请求失败. error = %@", [request error]);
    //NSError *error = [request error];
}

- (NSDictionary *)responseDataToJSONDictionary:(NSData *)response
{
//    NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
