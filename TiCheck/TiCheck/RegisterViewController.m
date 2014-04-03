//
//  RegisterViewController.m
//  TiCheck
//
//  Created by 邱峰 on 14-4-2.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "RegisterViewController.h"

#import "UserData.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation RegisterViewController

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
    self.password.secureTextEntry=YES;
    
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
    NSString* password=self.password.text;
    NSString* emai=self.email.text;
    
    if (account.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"账号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    if ([account rangeOfString:@""].location!=NSNotFound)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"账号不能有空格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    
    if (password.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }

#warning aleady register account;
//    if ()
//    {
//        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"该账号已被注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return ;
//
//    }
    [UserData sharedUserData].account=account;
    [UserData sharedUserData].password=password;
    [UserData sharedUserData].email=emai;
    
    if ([[UserData sharedUserData] loginWithAccout:account andPassword:password inViewController:self])
    {
     
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
