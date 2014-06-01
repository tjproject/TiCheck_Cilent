//
//  AccountEditDetailViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-11.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "AccountEditDetailViewController.h"
#import "UserData.h"
#import "ServerCommunicator.h"
#import "ConfigurationHelper.h"

@interface AccountEditDetailViewController ()
{
    //0 1 2 : account name, email password
    int _SetEditDetailType;
}

//if changing password, the first must be the old password
@property (strong, nonatomic) IBOutlet UITextField *firstField;
//confirm the new password
@property (strong, nonatomic) IBOutlet UITextField *secondField;

@property (strong, nonatomic) IBOutlet UIButton *seperateLine2;
@end

@implementation AccountEditDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.title=@"test";
        //NSLog(@"test");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //_SetEditDetailType=0;
    [self initTextFieldDisplay:_SetEditDetailType];

}

- (void)setEditDetailType:(int)type
{
    _SetEditDetailType=type;
    //[self initTextFieldDisplay:type];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTextFieldDisplay:(int) type
{
    
    switch (type) {
        case 0:
            //
            self.secondField.hidden=YES;
            self.seperateLine2.hidden=YES;
            self.firstField.placeholder=@"新邮箱";
            break;
        case 1:
            self.secondField.hidden=YES;
            self.seperateLine2.hidden=YES;
            self.firstField.placeholder=@"新用户名";
            break;
        case 2:
            //password
            self.firstField.secureTextEntry=YES;
            self.secondField.secureTextEntry=YES;
            break;
    }
}

- (IBAction)confirmButtonEvent:(id)sender
{
    //
    //NSLog(@"yes");
    
    NSString* firstS=self.firstField.text;
    NSString* secondS=self.secondField.text;
    
    
    
    switch (_SetEditDetailType) {
        case 0:
            //update email
            if ([self checkString:firstS WithName:@"邮箱"])
            {
                if ([self isValidEmail:firstS]) {
                    [UserData sharedUserData].email=firstS;
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            
            break;
        case 1:
            //update username
            if ([self checkString:firstS WithName:@"用户名"])
            {
                
                //update server
                 NSDictionary *returnDic=[[ServerCommunicator sharedCommunicator] modifyUserWithEmail:[UserData sharedUserData].email password:[UserData sharedUserData].password account:firstS pushable:[UserData sharedUserData].pushable];
                NSInteger returnCode = [returnDic[SERVER_RETURN_CODE_KEY] integerValue];
                if (returnCode == USER_LOGIN_SUCCESS)
                {
                    [UserData sharedUserData].userName=firstS;
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    alert.tag=1;
                }
                else
                {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"修改失败" message:@"该用户名已被注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                //[self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case 2:
            //update password after confirm the old one
            if([self checkString:firstS  WithName:@"旧密码"])
            {
                if([self checkString:secondS  WithName:@"新密码"])//firstS== [UserData sharedUserData].password)
                {
                    NSString *theRealOldPassword= [UserData sharedUserData].password;
                    NSString *textedByUser=[[ConfigurationHelper sharedConfigurationHelper] md5:firstS];
                    if( [theRealOldPassword isEqualToString:textedByUser] )
                    {
                        NSString *theNewOne=[[ConfigurationHelper sharedConfigurationHelper] md5:secondS];
                        
                        NSDictionary *returnDic=[[ServerCommunicator sharedCommunicator] modifyUserWithEmail:[UserData sharedUserData].email password:theNewOne account:[UserData sharedUserData].userName pushable:[UserData sharedUserData].pushable];
                        
                        NSInteger returnCode = [returnDic[SERVER_RETURN_CODE_KEY] integerValue];
                        if (returnCode == USER_LOGIN_SUCCESS)
                        {
                            [UserData sharedUserData].password=theNewOne;
                            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                            alert.tag=1;
                        }
                        else
                        {
                            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"修改失败" message:@"密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }

                        //[self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"修改失败" message:@"旧密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                }
            }
            break;
    }
    
    //更新服务器数据
    
}

- (BOOL)checkString:(NSString*)target WithName:(NSString*) name
{
    if (target.length==0)
    {
        NSString* messageS=[name stringByAppendingString:@"不能为空"];
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"修改失败" message: messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if ([target rangeOfString:@" "].location!=NSNotFound)
    {
        NSString* messageS=[name stringByAppendingString:@"不能有空格"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"修改失败" message:messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailValidate evaluateWithObject:email];
}

#pragma mark - ui alert delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"test");
    if (alertView.tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
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
