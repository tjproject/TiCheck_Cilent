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

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *userName;

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
    NSString* emailStr=self.email.text;
    NSString* passwordStr=self.password.text;
    NSString* userNameStr=self.userName.text;
    
    if (emailStr.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"邮箱不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    if (![self isValidEmail:emailStr])
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"邮箱格式错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    
    if (passwordStr.length==0)
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
    [UserData sharedUserData].email=emailStr;
    [UserData sharedUserData].password=passwordStr;
    [UserData sharedUserData].userName=userNameStr;
    
    if ([[UserData sharedUserData] loginWithAccout:emailStr andPassword:passwordStr inViewController:self])
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

- (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailValidate evaluateWithObject:email];
}

@end
