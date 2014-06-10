//
//  ConfigurationHelper.m
//  Test
//
//  Created by Boyi on 3/3/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "ConfigurationHelper.h"
#import "Passenger.h"
#import "CoreData+MagicalRecord.h"
#import "AppDelegate.h"

@interface ConfigurationHelper ()

@property (weak, nonatomic) AppDelegate *appDelegate;

@end

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
        // TODO: 默认设置
    }
    
    return self;
}

- (BOOL)isInternetConnection
{
    if ([self.appDelegate.internetReachability currentReachabilityStatus] == NotReachable) return false;
    else return true;
}

- (BOOL)isServerHostConnection
{
    if ([self.appDelegate.hostReachability currentReachabilityStatus] == NotReachable) return false;
    else return true;
}

- (NSString *)getHeaderStringWithRequestType:(FlightRequestType)requestType {
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *secretKeyMD5 = [self MD5ExtWithUpperCase:STATION_KEY];
    NSString *keyString = [timeStamp stringByAppendingFormat:@"%d%@%d%@", ALLIANCE_ID, secretKeyMD5, STATION_ID, cFlightRequestTypeString(requestType)];
    NSString *signature = [self MD5ExtWithUpperCase:keyString];
    
    NSString *header = [NSString stringWithFormat:@"&lt;Header AllianceID=\"%d\" SID=\"%d\" TimeStamp=\"%@\" RequestType=\"%@\" Signature=\"%@\" /&gt;\n", ALLIANCE_ID, STATION_ID, timeStamp, cFlightRequestTypeString(requestType), signature];

    return  header;
}

- (NSString *)getURLStringWithRequestType:(FlightRequestType)requestType
 {
    // the request type must be lower case when calculate the signature
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *secretKeyMD5 = [self MD5ExtWithUpperCase:STATION_KEY];
    NSString *keyString = [timeStamp stringByAppendingFormat:@"%d%@%d%@", ALLIANCE_ID, secretKeyMD5, STATION_ID,cFlightRequestTypeString(requestType) ];
    NSString *signature = [self MD5ExtWithUpperCase:keyString];
    NSString *header = [NSString stringWithFormat:@"?AllianceID=%d&SID=%d&TimeStamp=%@&Signature=%@&RequestType=%@", ALLIANCE_ID, STATION_ID, timeStamp, signature, cFlightRequestTypeString(requestType)];
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
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [ret appendFormat:@"%02x", result[i]];
    }

    return ret;
}

- (void)resetAll
{
    {
        NSArray *arr = [Passenger MR_findAll];
        for (NSManagedObject *obj in arr) {
            [obj MR_deleteEntity];
        }
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark - Helper

- (AppDelegate *)appDelegate
{
    if (_appDelegate == nil) {
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return _appDelegate;
}

@end
