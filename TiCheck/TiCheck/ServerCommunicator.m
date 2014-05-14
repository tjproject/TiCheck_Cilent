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
#import "APIResourceHelper.h"

#import "NSString+DateFormat.h"

#import "Subscription.h"
#import "UserData.h"
#import "DomesticCity.h"
#import "Airline.h"
#import "Airport.h"

#define STRING_NIL_THEN_EMPTY(string) (string == nil ? @"", string)

@implementation ServerCommunicator

+ (ServerCommunicator *)sharedCommunicator
{
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedCommunicator = nil;
    dispatch_once(&onceToken, ^{
        _sharedCommunicator = [[self alloc] init];
    });
    return _sharedCommunicator;
}

- (NSDictionary *)createUserWithEmail:(NSString *)email password:(NSString *)password account:(NSString *)account
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:account, @"Account", password, @"Password", email, @"Email", nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *requestString = [NSString stringWithFormat:@"User=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];

    NSData *responseData = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:Create_User jsonData:jsonBody];

    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)modifyUserWithEmail:(NSString *)newEmail password:(NSString *)newPassword account:(NSString *)newAccount
{
    NSDictionary *newUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:newAccount, @"Account", newPassword, @"Password", newEmail, @"Email", nil];
    NSDictionary *oldUserInfo = [self currentUserJsonDataDictionaryWithAccount:YES];
    
    NSData *newUserInfoJsonData = [NSJSONSerialization dataWithJSONObject:newUserInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *oldUserInfoJsonData = [NSJSONSerialization dataWithJSONObject:oldUserInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"User=%@&NewUser=%@", [[NSString alloc] initWithData:oldUserInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:newUserInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:Modify_User jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)loginVerifyWithEmail:(NSString *)email password:(NSString *)password
{
    NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys:email, @"Email", password, @"Password", nil];
    NSData *loginInfoJsonData = [NSJSONSerialization dataWithJSONObject:loginInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *requestString = [NSString stringWithFormat:@"User=%@", [[NSString alloc] initWithData:loginInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:User_Login jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)userInfoFetch
{
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    NSData *userInfoData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *requestString = [NSString stringWithFormat:@"User=%@", [[NSString alloc] initWithData:userInfoData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:User_Info jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)addTokenForCurrentUser:(NSString *)token
{
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"User=%@&DeviceToken=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding], token];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:Add_Token jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)removeTokenForCurrentUser:(NSString *)token
{
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"User=%@&DeviceToken=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding], token];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:Remove_Token jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)createSubscriptionWithSubscription:(Subscription *)subscription
{
    NSDictionary *subscriptionInfo = [subscription dictionaryWithSubscriptionOption];
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    
    NSData *subscriptionInfoJsonData = [NSJSONSerialization dataWithJSONObject:subscriptionInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"Subscription=%@&User=%@", [[NSString alloc] initWithData:subscriptionInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerSubscriptionResponseWithServerURL:SERVER_URL requestType:Create_Subscription jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)modifySubscriptionWithOldSubscription:(Subscription *)oldSubscription asNewSubscription:(Subscription *)newSubscription
{
    NSDictionary *oldSubscriptionInfo = [oldSubscription dictionaryWithSubscriptionOption];
    NSDictionary *newSubscriptionInfo = [newSubscription dictionaryWithSubscriptionOption];
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    
    NSData *oldSubscriptionInfoJsonData = [NSJSONSerialization dataWithJSONObject:oldSubscriptionInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *newSubscriptionInfoJsonData = [NSJSONSerialization dataWithJSONObject:newSubscriptionInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"Subscription=%@&NewSubscription=%@&User=%@", [[NSString alloc] initWithData:oldSubscriptionInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:newSubscriptionInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerSubscriptionResponseWithServerURL:SERVER_URL requestType:Modify_Subscription jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)cancelSubscriptionWithSubscription:(Subscription *)subscription
{
    NSDictionary *subscriptionInfo = [subscription dictionaryWithSubscriptionOption];
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    
    NSData *subscriptionInfoJsonData = [NSJSONSerialization dataWithJSONObject:subscriptionInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"Subscription=%@&User=%@", [[NSString alloc] initWithData:subscriptionInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerSubscriptionResponseWithServerURL:SERVER_URL requestType:Cancel_Subscription jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)getSubscriptionInfo
{
    
    //NSDictionary *subscriptionInfo = [subscription dictionaryWithSubscriptionOption];
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    
    //NSData *subscriptionInfoJsonData = [NSJSONSerialization dataWithJSONObject:subscriptionInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"User=%@",[[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerSubscriptionResponseWithServerURL:SERVER_URL requestType:Get_Subscription jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}


- (NSDictionary *)currentUserJsonDataDictionaryWithAccount:(BOOL)withAccount
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserData sharedUserData].email, @"Email", [UserData sharedUserData].password, @"Password", nil];
    if (withAccount) [result setObject:[UserData sharedUserData].userName forKey:@"Account"];
    
    return result;
}

- (NSDictionary *)responseDataToJSONDictionary:(NSData *)response
{
    NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
}

@end
