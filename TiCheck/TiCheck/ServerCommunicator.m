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

#pragma mark -
#pragma mark Singleton

+ (ServerCommunicator *)sharedCommunicator
{
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedCommunicator = nil;
    dispatch_once(&onceToken, ^{
        _sharedCommunicator = [[self alloc] init];
    });
    return _sharedCommunicator;
}

#pragma mark -
#pragma mark User

- (NSDictionary *)createUserWithEmail:(NSString *)email password:(NSString *)password account:(NSString *)account uniqueID:(NSString*) uid
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:account, @"Account", password, @"Password", email, @"Email", @"1",@"Pushable",uid,@"UID", nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *requestString = [NSString stringWithFormat:@"User=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];

    NSData *responseData = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:Create_User jsonData:jsonBody];

    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)modifyUserWithEmail:(NSString *)newEmail password:(NSString *)newPassword account:(NSString *)newAccount pushable:(NSString*) newPushable
{
    NSDictionary *newUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:newAccount, @"Account", newPassword, @"Password", newEmail, @"Email",newPushable,@"Pushable", [UserData sharedUserData].uniqueID ,@"UID",nil];
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

#pragma mark -
#pragma mark Token

- (NSDictionary *)addTokenForCurrentUser:(NSString *)token
{
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    if (userInfo == nil) {
        return nil;
    }
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

#pragma mark -
#pragma mark Subscription

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

#pragma mark -
#pragma mark Utilities

- (NSDictionary *)currentUserJsonDataDictionaryWithAccount:(BOOL)withAccount
{
    /**
     *  判断是否有用户
     */
    NSString *email = [UserData sharedUserData].email;
    if (email == nil) {
        return nil;
    }
    
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserData sharedUserData].email, @"Email", [UserData sharedUserData].password, @"Password", [UserData sharedUserData].pushable ,@"Pushable", [UserData sharedUserData].uniqueID, @"UID",nil];
    
    if (withAccount) [result setObject:[UserData sharedUserData].userName forKey:@"Account"];
    
    return result;
}

- (NSDictionary *)responseDataToJSONDictionary:(NSData *)response
{
//    NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    // TODO: 临时结局crash的问题
    if (response == nil) return [NSDictionary dictionary];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];

    return result;
}

- (NSDictionary *)responseDataToJSONDictionaryTest:(NSData *)response
{
    //    NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    // TODO: 临时结局crash的问题
    if (response == nil) return [NSDictionary dictionary];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    
    return result;
}
#pragma mark -
#pragma mark Order
- (NSDictionary *)addOrder:(Order *)orderDetail
{
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    NSDictionary *orderInfo = [orderDetail dictionaryWithOrderOption];
    
    //NSError *error = [[NSError alloc] init];
    if([NSJSONSerialization isValidJSONObject:orderInfo])
    {
        NSData *orderDetailJsonData = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
        //NSLog(@"%@", error);
        NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *OrderIDDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:orderDetail.OrderID,@"OrderID", nil];
        
        NSData *orderIdInfoJsonData = [NSJSONSerialization dataWithJSONObject:OrderIDDictionary options:NSJSONWritingPrettyPrinted error:nil];
        //
        NSString *requestString = [NSString stringWithFormat:@"OrderDetail=%@&User=%@&TempOrder=%@", [[NSString alloc] initWithData:orderDetailJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:orderIdInfoJsonData encoding:NSUTF8StringEncoding]];
        NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        
        //
        NSData *responseData = [ServerRequest getServerOrderResponseWithServerURL:SERVER_URL requestType:Create_Order jsonData:jsonBody];
        
        return [self responseDataToJSONDictionary:responseData];
    }
    else
    {
        //
    }
    return nil;
}

- (NSDictionary *)getOrderInfo:(NSString *)tempOrderID
{
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    //NSDictionary *orderInfo = [orderDetail dictionaryWithOrderOption];
    
    //NSError *error = [[NSError alloc] init];
    if([NSJSONSerialization isValidJSONObject:userInfo])
    {
        //NSLog(@"%@", error);
        NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
        
        //NSDictionary *OrderIDDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:orderDetail.OrderID,@"OrderID", nil];
        
        //NSData *orderIdInfoJsonData = [NSJSONSerialization dataWithJSONObject:OrderIDDictionary options:NSJSONWritingPrettyPrinted error:nil];
        //
        NSString *requestString = [NSString stringWithFormat:@"User=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
        NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        
        //
        NSData *responseData = [ServerRequest getServerOrderResponseWithServerURL:SERVER_URL requestType:Get_Order jsonData:jsonBody];
        
        return [self responseDataToJSONDictionaryTest:responseData];
    }
    return nil;
}

- (NSDictionary*)deleteOrder:(Order*)order
{
    NSDictionary *orderInfo = [order dictionaryWithOrderOption];
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    
    if([NSJSONSerialization isValidJSONObject:orderInfo])
    {
        NSData *orderDetailJsonData = [NSJSONSerialization dataWithJSONObject:orderInfo options:NSJSONWritingPrettyPrinted error:nil];
        //NSLog(@"%@", error);
        NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *OrderIDDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:order.OrderID,@"OrderID", nil];
        
        NSData *orderIdInfoJsonData = [NSJSONSerialization dataWithJSONObject:OrderIDDictionary options:NSJSONWritingPrettyPrinted error:nil];
        //
        NSString *requestString = [NSString stringWithFormat:@"User=%@&TempOrder=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:orderIdInfoJsonData encoding:NSUTF8StringEncoding]];
        NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",requestString);
        //
        NSData *responseData = [ServerRequest getServerOrderResponseWithServerURL:SERVER_URL requestType:Cancel_Order jsonData:jsonBody];
        
        return [self responseDataToJSONDictionary:responseData];
    }
    else{
    }
    return nil;
}


# pragma mark - contact

- (NSDictionary *)addContacts:(Passenger *)contact
{
    NSDictionary *contactInfo = [contact dictionaryWithPassengerOption];
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    
    NSData *contactInfoJsonData = [NSJSONSerialization dataWithJSONObject:contactInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"User=%@&Contacts=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:contactInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerContactResponseWithServerURL:SERVER_URL requestType:Create_Contact jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)getContacts:(NSArray *)contacts
{
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    
    //NSData *contactInfoJsonData = [NSJSONSerialization dataWithJSONObject:contactInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"User=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerContactResponseWithServerURL:SERVER_URL requestType:Get_Contact jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)modifyContact:(Passenger *)oldContact toNewContact:(Passenger *)newContact;
{
    NSDictionary *oldContactInfo = [oldContact dictionaryWithPassengerOption];
    NSDictionary *newContactInfo = [newContact dictionaryWithPassengerOption];
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    
    NSData *oldContactInfoJsonData = [NSJSONSerialization dataWithJSONObject:oldContactInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *newContactInfoJsonData = [NSJSONSerialization dataWithJSONObject:newContactInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"User=%@&Contacts=%@&NewContacts=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:oldContactInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:newContactInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerContactResponseWithServerURL:SERVER_URL requestType:Modify_Contact jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];

}

- (NSDictionary *)deleteContacts:(Passenger *)contact;
{
    NSDictionary *contactInfo = [contact dictionaryWithPassengerOption];
    NSDictionary *userInfo = [self currentUserJsonDataDictionaryWithAccount:NO];
    
    NSData *contactInfoJsonData = [NSJSONSerialization dataWithJSONObject:contactInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"User=%@&Contacts=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding], [[NSString alloc] initWithData:contactInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerContactResponseWithServerURL:SERVER_URL requestType:Cancel_Contact jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

#pragma mark - Airline

- (NSDictionary *)getAllAirlineCompany
{
    NSData *responseData = [ServerRequest getServerAirlineResponseWithServerURL:SERVER_URL requestType:Get_AirlineCompany jsonData:[[NSData alloc] init]];
    
    return [self responseDataToJSONDictionary:responseData];
}

- (NSDictionary *)addAirlineCount:(Airline *)airline
{
//    NSDictionary *airlineAdd = [NSDictionary dictionaryWithObjectsAndKeys:airline.airline, @"AirlineCompany", nil];
//    NSData *airlineAddJsonData = [NSJSONSerialization dataWithJSONObject:airlineAdd options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *requestString = [NSString stringWithFormat:@"AirlineCompany=%@", airline.airline];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *responseData = [ServerRequest getServerAirlineResponseWithServerURL:SERVER_URL requestType:Add_AirlineCount jsonData:jsonBody];
    
    return [self responseDataToJSONDictionary:responseData];
}

@end
