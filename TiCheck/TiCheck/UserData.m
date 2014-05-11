//
//  UserData.m
//  TiCheck
//
//  Created by 邱峰 on 14-4-2.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "UserData.h"
#import "ConfigurationHelper.h"
#import "ServerCommunicator.h"

@implementation UserData

@synthesize email=_email;
@synthesize password=_password;
@synthesize userName=_userName;
@synthesize uniqueID=_uniqueID;

+(UserData*) sharedUserData
{
    static UserData* userData=nil;
    
    static dispatch_once_t userDataToken ;
    dispatch_once(&userDataToken, ^(){
        userData=[[UserData alloc] init];
    });
    
    return userData;
}

-(void) setEmail:(NSString *)account
{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) setUserName:(NSString *)email
{
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) setUniqueID:(NSString *)uniqueID
{
    [[NSUserDefaults standardUserDefaults] setObject:uniqueID forKey:@"uniqueID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*) email
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
}

-(NSString*) password
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

-(NSString*) userName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
}

-(NSString*) uniqueID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueID"];
}

-(BOOL) loginWithAccout:(NSString *)email andPassword:(NSString *)password inViewController:(UIViewController *)viewController
{
    BOOL result = NO;
    NSDictionary *returnDic = [[ServerCommunicator sharedCommunicator] loginVerifyWithEmail:email password:password];
    NSInteger returnCode = [returnDic[SERVER_RETURN_CODE_KEY] integerValue];
    
    if (returnCode == USER_LOGIN_SUCCESS) {
        self.email=email;
        self.password=password;
        
        //get user name
        NSDictionary *dic=[[ServerCommunicator sharedCommunicator] userInfoFetch];
        NSDictionary *userDic=dic[SERVER_USER_DATA];
        self.userName= userDic[@"Account"];
        
        UIStoryboard* storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* nextController = [storyBoard instantiateViewControllerWithIdentifier:@"TiCheckViewStoryboardID"];
        [viewController.navigationController pushViewController:nextController animated:YES];
        result = YES;
        
    } else {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"邮箱或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    return result;
}

-(BOOL) autoLoginInViewController:(UIViewController *)viewController
{
    NSString* account=self.email;
    NSString* password=self.password;
    if (account && password)
    {
        return [self loginWithAccout:account andPassword:password inViewController:viewController];
    }
    else return NO;
}

@end
