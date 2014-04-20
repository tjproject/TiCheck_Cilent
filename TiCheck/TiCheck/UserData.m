//
//  UserData.m
//  TiCheck
//
//  Created by 邱峰 on 14-4-2.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "UserData.h"
#import "ConfigurationHelper.h"

@implementation UserData

@synthesize email=_email;
@synthesize password=_password;
@synthesize userName=_userName;

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
    [[NSUserDefaults standardUserDefaults] setObject:[[ConfigurationHelper sharedConfigurationHelper] md5:password] forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) setUserName:(NSString *)email
{
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
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

-(BOOL) loginWithAccout:(NSString *)email andPassword:(NSString *)password inViewController:(UIViewController *)viewController
{
    self.email=email;
    self.password=password;
    UIStoryboard* storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* nextController = [storyBoard instantiateViewControllerWithIdentifier:@"TiCheckViewStoryboardID"];
    [viewController.navigationController pushViewController:nextController animated:YES];
    return YES;
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
