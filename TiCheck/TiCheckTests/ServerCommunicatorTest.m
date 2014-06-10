//
//  ServerCommunicatorTest.m
//  TiCheck
//
//  Created by Ming Yang on 6/7/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ServerCommunicator.h"
#import "Airline.h"
#import "Subscription.h"
#import "UserData.h"

//#define DEBUG_MODE 1

@interface ServerCommunicatorTest : XCTestCase


@end

@implementation ServerCommunicatorTest
bool isUserCreated;
bool isUserLoggedIn;
bool isDeviceAdded;
bool isSubscriptionAdded;
ServerCommunicator *_server;
NSString *_mail;
NSString *_passwd;
NSString *_deviceToken;
Subscription *_subs;

+ (void)setUp
{
    isUserCreated = false;
    isUserLoggedIn = false;
    isDeviceAdded = false;
    isSubscriptionAdded = false;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmSS"];
    NSString *date = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    //    NSLog(@"date: %@", date);
    _mail = [NSString stringWithFormat:@"%@@test.com", date];
    _server = [ServerCommunicator sharedCommunicator];
    _passwd = @"asdfghjkl";
    _deviceToken = @"asdfghjkl";
    
    _subs = [[Subscription alloc] initWithDepartCity:@"北京" arriveCity:@"上海" startDate:@"2015-11-11" endDate:@"2015-12-11"];
    
    [UserData sharedUserData].email=@"";
    [UserData sharedUserData].password=@"";
    [UserData sharedUserData].userName=@"";
    [UserData sharedUserData].uniqueID = @"";
    [UserData sharedUserData].pushable = @"";
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - User

#pragma mark create
- (void)testCreateUser
{
    if (isUserCreated) {
        return;
    }
    NSString *mail = [NSString stringWithFormat:_mail, [NSDateFormatter dateFormatFromTemplate:@"ymds" options:0 locale:[NSLocale currentLocale]]];
    NSLog(@"%@", mail);
    NSDictionary *result = [_server createUserWithEmail:mail password:@"asdfghjkl" account:@"" uniqueID:@""];
#if DEBUG_MODE
    NSLog(@"create user result: %@", result);
#endif
    XCTAssertEqual([result[@"Code"] integerValue], 1, @"create user failed");
    isUserCreated = [result[@"Code"] intValue]==1 ? true : false;
}

- (void)testCreateUserEmailFormatNoAt
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa" password:@"asdfghjkl" account:@"" uniqueID:@""];
//    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
    result = [_server createUserWithEmail:@"aaa@a" password:@"asdfghjkl" account:@"" uniqueID:@""];
//    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserEmailFormatNoDomain
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa@a" password:@"asdfghjkl" account:@"" uniqueID:@""];
//    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserEmailFormatNoAtButHasDot
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa.a" password:@"asdfghjkl" account:@"" uniqueID:@""];
//    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserPasswordFormatOneChar
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa@aaa.com" password:@"a" account:@"" uniqueID:@""];
//    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserPasswordFormatEmpty
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa@aaa.com" password:@"" account:@"" uniqueID:@""];
//    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserPasswordFormatLengthMax
{
    NSString *passwd = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    XCTAssertEqual(passwd.length, 65, @"passwd length not equals 65");
    NSDictionary *result = [_server createUserWithEmail:@"aaa@aaa.com" password:passwd account:@"" uniqueID:@""];
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserPasswordFormatLengthMin
{
    NSString *passwd = @"aaaa";
    XCTAssertEqual(passwd.length, 4, @"passwd length not equals 5");
    NSDictionary *result = [_server createUserWithEmail:@"aaa@aaa.com" password:passwd account:@"" uniqueID:@""];
//    NSLog(@"passwd min: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

#pragma mark log in
- (void)testLogin
{
    if (!isUserCreated) {
        [self testCreateUser];
    }
    if (isUserLoggedIn) {
        return;
    }
    NSDictionary *result = [_server loginVerifyWithEmail:_mail password:@"asdfghjkl"];

    
//    NSLog(@"log in result: %@", result);
    XCTAssertEqual([result[@"Code"] intValue], 1, @"log in failed");
    if ([result[@"Code"] intValue]==1) {
        isUserLoggedIn = true;
        [UserData sharedUserData].email = _mail;
        [UserData sharedUserData].password = _passwd;
    }
}

#pragma mark device token
- (void)testAddDeviceToken
{
    if (isDeviceAdded) {
        return;
    }
    [self testLogin];
    NSDictionary *result = [_server addTokenForCurrentUser:_deviceToken];
    XCTAssertEqual([result[@"Code"] intValue], 1, @"add device token failed");
    if ([result[@"Code"] intValue] == 1) {
        isDeviceAdded = true;
    }
}

- (void)testRemoveDevice
{
    [self testAddDeviceToken];
    NSDictionary *result = [_server removeTokenForCurrentUser:_deviceToken];
    int code = [result[@"Code"] intValue];
    XCTAssertEqual(code, 1, @"remove device failed");
    if (code == 1) {
        isDeviceAdded = false;
    }
}

#pragma mark - Subscription
- (void)testCreateSubscription
{
    if (isSubscriptionAdded) {
        return;
    }
    [self testLogin];
    NSDictionary *result = [_server createSubscriptionWithSubscription:_subs];
#if DEBUG_MODE
    NSLog(@"subscription result: %@", result);
#endif
    int code = [result[@"Code"] intValue];
    XCTAssertEqual(code, 1, @"create subscription failed");
    if (code == 1) {
        isSubscriptionAdded = true;
    }
}

- (void)testModifySubscription
{
    [self testLogin];
    [self testCreateSubscription];
    Subscription *newSubs = [[Subscription alloc] initWithDepartCity:@"上海" arriveCity:@"北京" startDate:@"2014-6-14" endDate:@"2014-6-15"];
    NSDictionary *result = [_server modifySubscriptionWithOldSubscription:_subs asNewSubscription:newSubs];
#if DEBUG_MODE
    NSLog(@"modify result: %@", result);
#endif
    int code = [result[@"Code"] intValue];
    XCTAssertEqual(code, 1, @"modify subscription failed");
}

#pragma mark - Airline Company
- (void)testGetAirline
{
    NSDictionary *result = [_server getAllAirlineCompany];
    NSArray *airlines = result[@"Data"];
    XCTAssertEqual(airlines.count, 195, @"Airlines returned not enough");
}

- (void)testAddAirlineCount
{
    Airline *airline = [[Airline alloc] init];
    airline.airline = @"3U";
    NSDictionary *result = [_server addAirlineCount:airline];
    XCTAssertEqual([result[@"Code"] intValue], 1, @"add airline company count failed");
}

@end
