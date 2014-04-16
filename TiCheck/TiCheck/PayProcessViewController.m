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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - set complex string for info display
- (void)setFlightLocation:(NSString*)fromLocation AndToLoaction:(NSString*)toLocation
{
    //use two lacation to generate string like the formate: xxx 至 xxx
    //
}


- (void)setFlightLogo:(NSString*) airlineName
{
    //get the image of airlineName;
    //self.flightLogoImage.image=[UIImage imageNamed:(NSString *)];
    //or other function...
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
