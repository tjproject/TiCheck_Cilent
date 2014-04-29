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

- (BOOL)createUserWithEmail:(NSString *)email password:(NSString *)password
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"sadkjsd", @"Account", password, @"Password", email, @"Email", nil];
    NSData *userInfoJsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *requestString = [NSString stringWithFormat:@"User=%@", [[NSString alloc] initWithData:userInfoJsonData encoding:NSUTF8StringEncoding]];
    NSData *jsonBody = [requestString dataUsingEncoding:NSUTF8StringEncoding];

    NSString *responseString = [ServerRequest getServerUserResponseWithServerURL:SERVER_URL requestType:Create_User jsonData:jsonBody];
    
    return YES;
}

@end
