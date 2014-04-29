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
@"login", nil] : ___UserRequestType)

#define cUserRequestTypeString(type) ([cUserRequestTypeGet objectAtIndex:type])
#define cUserRequestTypeEnum(string) ([cUserRequestTypeGet indexOfObject:string])

const NSArray *___SubscriptionRequestType;

#define cSubscriptionRequestTypeGet (___SubscriptionRequestType == nil ? ___SubscriptionRequestType = [[NSArray alloc] initWithObjects:\
@"create",\
@"cancel",\
@"modify", nil] : ___SubscriptionRequestType)

#define cSubscriptionRequestTypeString(type) ([cSubscriptionRequestTypeGet objectAtIndex:type])
#define cSubscriptionRequestTypeEnum(string) ([cSubscriptionRequestTypeGet indexOfObject:string])

@implementation ServerRequest

+ (NSString *)getServerUserResponseWithServerURL:(NSString *)serverUrl
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
    NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:nil];
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

+ (NSString *)getServerSubscriptionResponseWithServerURL:(NSString *)serverUrl
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
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

@end
