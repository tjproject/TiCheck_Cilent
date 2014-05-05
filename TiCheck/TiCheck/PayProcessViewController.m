//
//  PayProcessViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-16.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PayProcessViewController.h"

@interface PayProcessViewController ()

@end

@implementation PayProcessViewController

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
    
    [self initInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.flightPassengerNameLabel.text = (NSString*)[self.passengerList objectAtIndex:0];

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
    return (self.selectFlight.price + self.selectFlight.adultOilFee + self.selectFlight.adultTax);
}




#pragma mark - pay 
- (IBAction)confirmPayButton:(id)sender
{
    NSLog(@"confirm,Pay");
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"支付中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    
    //TODO: when clicked, jump to a web page to continue the pay process
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
