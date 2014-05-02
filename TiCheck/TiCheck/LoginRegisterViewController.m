//
//  LoginViewController.m
//  TiCheck
//
//  Created by 邱峰 on 14-4-2.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "UserData.h"

@interface LoginRegisterViewController ()<UINavigationControllerDelegate>

@end

@implementation LoginRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController==self)
    {
        navigationController.navigationBar.hidden=YES;
    }
    else
    {
        navigationController.navigationBar.hidden=NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate=self;

    if ([UserData sharedUserData].email.length!=0) {
        [[UserData sharedUserData] autoLoginInViewController:self];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
