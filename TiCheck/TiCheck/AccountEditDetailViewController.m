//
//  AccountEditDetailViewController.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-11.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "AccountEditDetailViewController.h"
#import "UserData.h"
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
            self.firstField.placeholder=@"新用户名";
            break;
        case 1:
            self.secondField.hidden=YES;
            self.seperateLine2.hidden=YES;
            self.firstField.placeholder=@"新邮箱";
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
    NSLog(@"yes");
    
    NSString* firstS=self.firstField.text;
    NSString* secondS=self.secondField.text;
    
    
    
    switch (_SetEditDetailType) {
        case 0:
            //update name
            if ([self checkString:firstS WithName:@"用户名"])
            {
                [UserData sharedUserData].account=firstS;
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            break;
        case 1:
            //update email
            if ([self checkString:firstS WithName:@"邮箱"])
            {
                [UserData sharedUserData].email=firstS;
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case 2:
            //update password after confirm the old one
            if([self checkString:firstS  WithName:@"旧密码"])
            {
                //TODO: password check
                if(YES)//firstS== [UserData sharedUserData].password)
                {
                    if([self checkString:secondS  WithName:@"新密码"])
                    {
                        [UserData sharedUserData].password=secondS;
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"修改失败" message:@"旧密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            break;
    }
    
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
    
    if ([target rangeOfString:@""].location!=NSNotFound)
    {
        NSString* messageS=[name stringByAppendingString:@"不能有空格"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"修改失败" message:messageS delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
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
