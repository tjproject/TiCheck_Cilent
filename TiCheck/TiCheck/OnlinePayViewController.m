//
//  OnlinePayViewController.m
//  TiCheck
//
//  Created by Boyi on 4/22/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "OnlinePayViewController.h"
#import "ConfigurationHelper.h"

#define WEB_ONLINE_PAYMENT_URL @"http://openapi.ctrip.com/Flight/PaymentEntry.aspx"

#define ALLIANCE_ID_KEY @"AllianceId"
#define STATION_ID_KEY @"SID"
#define TIMESTAMP_KEY @"TimeStamp"
#define SIGNATURE_KEY @"Signature"
#define REQUEST_TYPE @"RequestType"

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
    
    [self setGetParameterForURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

- (NSURL *)setGetParameterForURL
{
    NSString *allianceId = [NSString stringWithFormat:@"%@=%d", ALLIANCE_ID_KEY, ALLIANCE_ID];
    NSString *sid = [NSString stringWithFormat:@"%@=%d", STATION_ID_KEY, STATION_ID];
    NSString *nowTimeStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *timestamp = [NSString stringWithFormat:@"%@=%@", TIMESTAMP_KEY, nowTimeStamp];
    NSArray *parameters = [NSArray array];
    
    
    return nil;
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
