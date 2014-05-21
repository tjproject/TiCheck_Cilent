//
//  LoginViewController.m
//  TiCheck
//
//  Created by 邱峰 on 14-4-2.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerCommunicator.h"
#import "ConfigurationHelper.h"
#import "UserData.h"
#import "AppDelegate.h"
#import "ServerRequest.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

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

- (IBAction)enter:(id)sender
{
    NSString* account=self.userName.text;
    NSString* password=[[ConfigurationHelper sharedConfigurationHelper] md5:self.password.text];
    
    NSDictionary *tempD = [[ServerCommunicator sharedCommunicator] addTokenForCurrentUser:mDeviceToken];
    NSLog(@"%@",tempD);
    
    [[UserData sharedUserData] loginWithAccout:account andPassword:password inViewController:self];
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
