//
//  RegisterViewController.m
//  TiCheck
//
//  Created by 邱峰 on 14-4-2.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "RegisterViewController.h"
#import "ServerCommunicator.h"
#import "ConfigurationHelper.h"
#import "UserData.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "OTAUserUniqueID.h"
#import "OTAUserUniqueIDResponse.h"
#import "SoapRequest.h"
#import "MBProgressHUD.h"

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
    if(![[ConfigurationHelper sharedConfigurationHelper] isInternetConnection])
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请检查网络重新注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    else
    {
        if (![[ConfigurationHelper sharedConfigurationHelper] isServerHostConnection]) {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"服务器维护中" message:@"服务器例行维护中，稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        else
        {
            [self.email resignFirstResponder];
            [self.password resignFirstResponder];
            [self.userName resignFirstResponder];
            
            
            
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
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText = @"注册中";
            
            passwordStr = [[ConfigurationHelper sharedConfigurationHelper] md5:passwordStr];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //先获取UniqueID
                
                NSString *uniqueID = [self sendUniqueIDRequest:emailStr];
                if (uniqueID != nil)
                {
                    NSDictionary *responseDic = [[ServerCommunicator sharedCommunicator] createUserWithEmail:emailStr password:passwordStr account:userNameStr uniqueID:uniqueID];
                    
                    NSInteger returnCode = [responseDic[SERVER_RETURN_CODE_KEY] integerValue];
                    
                    if (returnCode == USER_CREATE_SUCCESS) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                            hud.mode = MBProgressHUDModeCustomView;
                            hud.labelText = @"注册成功";
                            [hud removeFromSuperview];
                            
                            [UserData sharedUserData].email = emailStr;
                            [UserData sharedUserData].password = passwordStr;
                            [UserData sharedUserData].userName = userNameStr;
                            [UserData sharedUserData].uniqueID = uniqueID;
                            
                            if ([[UserData sharedUserData] loginWithAccout:emailStr andPassword:passwordStr inViewController:self])
                            {
                            }
                        });
                    }
                    else if (returnCode == USER_CREATE_DUPLICATE_EMAIL)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud removeFromSuperview];
                            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"该账号已被注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        });
                    }
                    else if (returnCode == USER_CREATE_FORMAT_ERROR)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud removeFromSuperview];
                            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"邮箱/密码/账号格式错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        });
                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud removeFromSuperview];
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    });
                }
            });
        }
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

- (NSString *)sendUniqueIDRequest:(NSString*)email
{
    OTAUserUniqueID *idRequest = [[OTAUserUniqueID alloc] initWithUserName:email telNumber:@""];
    NSString *requsetXML = [idRequest generateOTAUserUniqueIDXMLRequest];
    ASIHTTPRequest *asiUniqueIDRequest = [SoapRequest getASISoap12RequestWithURL:API_URL
                                               flightRequestType:UserUniqueID
                                                    xmlNameSpace:XML_NAME_SPACE
                                                  webServiceName:WEB_SERVICE_NAME
                                                  xmlRequestBody:requsetXML];
    NSDictionary *mainUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"asiRequestType", nil];
    
    [asiUniqueIDRequest setUserInfo:mainUserInfo];
    [asiUniqueIDRequest setDelegate:self];
    [asiUniqueIDRequest startSynchronous];
    //获取user id
    OTAUserUniqueIDResponse *response = [[OTAUserUniqueIDResponse alloc] initWithOTAUserUniqueIDResponse:[asiUniqueIDRequest responseString]];
    if (response.retCode == 0)
    {
        NSLog(@"Unique ID = %@",response.uniqueUID);
        //[UserData sharedUserData].uniqueID = response.uniqueUID;
        return response.uniqueUID;
    }
    return nil;
    //[asiUniqueIDRequest star]
}


- (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailValidate evaluateWithObject:email];
}

@end
