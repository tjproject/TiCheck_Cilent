//
//  ConfigurationHelper.m
//  Test
//
//  Created by Boyi on 3/3/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "ConfigurationHelper.h"

@implementation ConfigurationHelper

+ (id)sharedConfigurationHelper
{
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedConfigurationHelper = nil;
    dispatch_once(&onceToken, ^{
        _sharedConfigurationHelper = [[self alloc] initWithDefaultSetting];
    });;
    return _sharedConfigurationHelper;
}

- (id)initWithDefaultSetting
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (NSString *)getHeaderStringWithRequestType:(FlightRequestType)requestType {
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *secretKeyMD5 = [self MD5ExtWithUpperCase:STATION_KEY];
    NSString *keyString = [timeStamp stringByAppendingFormat:@"%d%@%d%@", ALLIANCE_ID, secretKeyMD5, STATION_ID, cFlightRequestTypeString(requestType)];
    NSString *signature = [self MD5ExtWithUpperCase:keyString];
    
    NSString *header = [NSString stringWithFormat:@"<Header Alliance=\"%d\" SID=\"%d\" TimeStamp=\"%@\" RequestType=\"%@\" Signature=\"%@\" />\n", ALLIANCE_ID, STATION_ID, timeStamp, cFlightRequestTypeString(requestType), signature];

    return  header;
}

/**
 *  MD5 32位加密算法，结果转换为大写
 *
 *  @param string 待加密的字串
 *
 *  @return 加密后并转换为大写的字串
 */
- (NSString *)MD5ExtWithUpperCase:(NSString *)string {
    NSString *ret = [self md5:string];
    return [ret uppercaseString];
}

/**
 *  MD5 32位加密算法
 *
 *  @param string 待加密的字串
 *
 *  @return 加密后的字串
 */
- (NSString *)md5:(NSString *)string
{
    const char *str = [string UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; ++i) {
        [ret appendFormat:@"%02x", result[i]];
    }

    return ret;
}

@end
