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

@synthesize account=_account;
@synthesize password=_password;
@synthesize email=_email;

+(UserData*) sharedUserData
{
    static UserData* userData=nil;
    
    static dispatch_once_t userDataToken ;
    dispatch_once(&userDataToken, ^(){
        userData=[[UserData alloc] init];
    });
    
    return userData;
}

-(void) setAccount:(NSString *)account
{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:[[ConfigurationHelper sharedConfigurationHelper] md5:password] forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) setEmail:(NSString *)email
{
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*) account
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
}

-(NSString*) password
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

-(NSString*) email
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
}

-(BOOL) loginWithAccout:(NSString *)account andPassword:(NSString *)password
{
    return YES;
}

@end
