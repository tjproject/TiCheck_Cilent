//
//  ServerRequest.m
//  TiCheck
//
//  Created by Boyi on 4/28/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "ServerRequest.h"
#import "ASIHTTPRequest.h"

const NSArray *___UserRequestType;

#define cUserRequestTypeGet (___UserRequestType == nil ? ___UserRequestType = [[NSArray alloc] initWithObjects:\
@"create",\
@"modify",\
@"login",\
@"info",\
@"deviceToken/add",\
@"deviceToken/remove", nil] : ___UserRequestType)

#define cUserRequestTypeString(type) ([cUserRequestTypeGet objectAtIndex:type])
#define cUserRequestTypeEnum(string) ([cUserRequestTypeGet indexOfObject:string])

const NSArray *___SubscriptionRequestType;

#define cSubscriptionRequestTypeGet (___SubscriptionRequestType == nil ? ___SubscriptionRequestType = [[NSArray alloc] initWithObjects:\
@"create",\
@"cancel",\
@"modify",\
@"info", nil] : ___SubscriptionRequestType)

#define cSubscriptionRequestTypeString(type) ([cSubscriptionRequestTypeGet objectAtIndex:type])
#define cSubscriptionRequestTypeEnum(string) ([cSubscriptionRequestTypeGet indexOfObject:string])

const NSArray *___OrderRequestType;

#define cOrderRequestTypeGet (___OrderRequestType == nil ? ___OrderRequestType = [[NSArray alloc] initWithObjects:\
@"add",\
@"delete",\
@"info", nil] : ___OrderRequestType)

#define cOrderRequestTypeString(type) ([cOrderRequestTypeGet objectAtIndex:type])
#define cOrderRequestTypeEnum(string) ([cOrderRequestTypeGet indexOfObject:string])


const NSArray *___ContactRequestType;

#define cContactRequestTypeGet (___ContactRequestType == nil ? ___ContactRequestType = [[NSArray alloc] initWithObjects:\
@"add",\
@"delete",\
@"modify",\
@"info", nil] : ___ContactRequestType)

#define cContactRequestTypeString(type) ([cContactRequestTypeGet objectAtIndex:type])
#define cContactRequestTypeEnum(string) ([cContactRequestTypeGet indexOfObject:string])

const NSArray *___AirlineRequestType;

#define cAirlineRequestTypeGet (___AirlineRequestType == nil ? ___AirlineRequestType = [[NSArray alloc] initWithObjects:\
@"info",\
@"add", nil] : ___AirlineRequestType)

#define cAirlineRequestTypeString(type) ([cAirlineRequestTypeGet objectAtIndex:type])
#define cAirlineRequestTypeEnum(string) ([cAirlineRequestTypeGet indexOfObject:string])


@implementation ServerRequest

+ (NSData *)getServerUserResponseWithServerURL:(NSString *)serverUrl
                                     requestType:(ServerUserRequestType)userRequestType
                                        jsonData:(NSData *)jsonData
{
    NSString *urlStr = [serverUrl stringByAppendingFormat:@"?r=User/%@", cUserRequestTypeString(userRequestType)];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    
    NSURLResponse *response = nil;
    NSError* error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    return result;
}

+ (NSData *)getServerSubscriptionResponseWithServerURL:(NSString *)serverUrl
                                             requestType:(ServerSubscriptionRequestType)subscriptionRequestType
                                                jsonData:(NSData *)jsonData
{
    NSString *urlStr = [serverUrl stringByAppendingFormat:@"?r=Subscription/%@", cSubscriptionRequestTypeString(subscriptionRequestType)];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSURLResponse *response = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:nil];
    return result;
}

+ (NSData *)getServerOrderResponseWithServerURL:(NSString *)serverUrl
                                           requestType:(ServerOrderRequestType)orderRequestType
                                              jsonData:(NSData *)jsonData
{
    NSString *urlStr = [serverUrl stringByAppendingFormat:@"?r=Order/%@", cOrderRequestTypeString(orderRequestType)];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSURLResponse *response = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:nil];
    return result;
}

+ (NSData *)getServerContactResponseWithServerURL:(NSString *)serverUrl
                                      requestType:(ServerContactRequestType)contactRequestType
                                         jsonData:(NSData *)jsonData
{
    NSString *urlStr = [serverUrl stringByAppendingFormat:@"?r=Contact/%@", cContactRequestTypeString(contactRequestType)];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSURLResponse *response = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:nil];
    return result;
}

+ (NSData *)getServerAirlineResponseWithServerURL:(NSString *)serverUrl
                                      requestType:(ServerAirlineRequestType)airlineRequestType
                                         jsonData:(NSData *)jsonData
{
    NSString *urlString = [serverUrl stringByAppendingFormat:@"?r=AirlineCompany/%@", cAirlineRequestTypeString(airlineRequestType)];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSURLResponse *response = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:nil];
    return result;
}

@end
