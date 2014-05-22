//
//  OnlinePayViewController.m
//  TiCheck
//
//  Created by Boyi on 4/22/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "OnlinePayViewController.h"
#import "ConfigurationHelper.h"
#import "OrderInfoViewController.h"
#import "ServerCommunicator.h"
#define WEB_ONLINE_PAYMENT_URL @"http://openapi.ctrip.com/Flight/PaymentEntry.aspx"

#define ALLIANCE_ID_KEY @"AllianceId"
#define STATION_ID_KEY @"SID"
#define TIMESTAMP_KEY @"TimeStamp"
#define SIGNATURE_KEY @"Signature"
#define REQUEST_TYPE @"RequestType"
#define SEGUE_TAG 4000

@interface OnlinePayViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *onlinePayWebView;

@end

@implementation OnlinePayViewController

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
    
    [self initNavigationBar];
    //[self setGetParameterForURL];
    [self loadWebUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar
{
    self.navigationItem.title = @"支付";
    // 添加 取消/完成按钮
    UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonSystemItemDone target:self action:@selector(doneButtonFunction:)];

    self.navigationItem.rightBarButtonItem=done;
}

#pragma mark - Helper Methods

- (NSURL *)setGetParameterForURL
{
//    NSString *allianceId = [NSString stringWithFormat:@"%@=%d", ALLIANCE_ID_KEY, ALLIANCE_ID];
//    NSString *sid = [NSString stringWithFormat:@"%@=%d", STATION_ID_KEY, STATION_ID];
//    NSString *nowTimeStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
//    NSString *timestamp = [NSString stringWithFormat:@"%@=%@", TIMESTAMP_KEY, nowTimeStamp];
//    NSArray *parameters = [NSArray array];  
    return nil;
}

- (void)loadWebUrl
{
    NSURL *url = self.url;
    
    // set the post body
    // and post body encode must be GB2312
    NSString *body = [NSString stringWithFormat: @"ReturnUrl=%@&Description=%@&ShowUrl=%@&PaymentDescription=%@&OrderID=%@&OrderType=%@&Language=%@&OrderSummary=%@",@"http://www.baidu.com",@"test",@"http://www.baidu.com",@"test",self.flightOrder.OrderID,@"1",@"ZH",@"test"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [self UTF8_To_GB2312:body]];
    [self.onlinePayWebView loadRequest: request];
}

- (NSData*)UTF8_To_GB2312:(NSString*)utf8string
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [utf8string dataUsingEncoding:encoding];
    return gb2312data; //[[NSString alloc] initWithData:gb2312data encoding:encoding];
}

- (void) doneButtonFunction:(id) sender
{
    NSLog(@"finished pay");
    //send order to server
    NSDictionary *returnDic = [[ServerCommunicator sharedCommunicator] addOrder:self.flightOrder];
    NSInteger returnCode = [returnDic[SERVER_RETURN_CODE_KEY] integerValue];
    
    
    if(returnCode == USER_LOGIN_SUCCESS)
    {

        
        //go into ticket info and pass order
        
        [self sendToOrderInfo];
    }
}

- (void) sendToOrderInfo
{
    OrderInfoViewController *oiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderInfoViewController"];
    oiVC.OIVC_Order = self.flightOrder;
    oiVC.OIVC_departureDate = self.departureDate;
    oiVC.segueFromOnlinePayTag = SEGUE_TAG;
    [self.navigationController pushViewController:oiVC animated:YES];
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
