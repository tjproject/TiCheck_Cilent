//
//  ServerCommunicator.m
//  TiCheck
//
//  Created by Boyi on 4/28/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "ServerCommunicator.h"
#import "ServerRequest.h"
#import "ConfigurationHelper.h"
#import "UserData.h"

@implementation ServerCommunicator

+ (ServerCommunicator *)sharedCommunicator
{
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedCommunicator = nil;
    dispatch_once(&onceToken, ^{
        _sharedCommunicator = [[self alloc] init];
    });;
    return _sharedCommunicator;
}

- (BOOL)createUserWithEmail:(NSString *)email password:(NSString *)password account:(NSString *)account
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:account, @"Account", password, @"Password", email, @"Email", nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *requestString = [NSString stringWithFormat:@"User=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];

    NSString *responseString = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:Create_User jsonData:jsonBody];
    
    return YES;
}

- (BOOL)modifyUserWithEmail:(NSString *)newEmail password:(NSString *)newPassword account:(NSString *)newAccount
{
    NSDictionary *newUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:newAccount, @"Account", newPassword, @"Password", newEmail, @"Email", nil];
    NSDictionary *oldUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:[UserData sharedUserData].userName, @"Account", [UserData sharedUserData].password, @"Password", [UserData sharedUserData].email, @"Email", nil];
    
    NSData *newUserInfoJsonData = [NSJSONSerialization dataWithJSONObject:newUserInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *oldUserInfoJsonData = [NSJSONSerialization dataWithJSONObject:oldUserInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"User=%@&NewUser=%@", [[NSString alloc] initWithData:oldUserInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:newUserInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *responseString = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:Modify_User jsonData:jsonBody];
    
    return YES;
}

@end
