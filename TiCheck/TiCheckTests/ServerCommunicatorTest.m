//
//  ServerCommunicatorTest.m
//  TiCheck
//
//  Created by Ming Yang on 6/7/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ServerCommunicator.h"

@interface ServerCommunicatorTest : XCTestCase
@property (nonatomic, weak) ServerCommunicator *server;
@end

@implementation ServerCommunicatorTest
@synthesize server = _server;
- (void)setUp
{
    [super setUp];
    _server = [ServerCommunicator sharedCommunicator];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateUser
{
    NSDictionary *result = [_server createUserWithEmail:@"hello@test.com" password:@"asdfghjkl" account:@"okaaa" uniqueID:@"sdfghjtyui"];
    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 1, @"meesage returned wrongly");
}

- (void)testCreateUserEmailFormat1
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa" password:@"asdfghjkl" account:@"" uniqueID:@""];
    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
    result = [_server createUserWithEmail:@"aaa@a" password:@"asdfghjkl" account:@"" uniqueID:@""];
    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserEmailFormat2
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa@a" password:@"asdfghjkl" account:@"" uniqueID:@""];
    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserEmailFormat3
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa.a" password:@"asdfghjkl" account:@"" uniqueID:@""];
    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserPasswordFormatOneChar
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa@aaa.com" password:@"a" account:@"" uniqueID:@""];
    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

- (void)testCreateUserPasswordFormatEmpty
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa@aaa.com" password:@"" account:nil uniqueID:nil];
    NSLog(@"returned dictionary: %@", result);
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
    NSString *passwd = @"aaaaa";
    XCTAssertEqual(passwd.length, 5, @"passwd length not equals 5");
    NSDictionary *result = [_server createUserWithEmail:@"aaa@aaa.com" password:passwd account:@"" uniqueID:@""];
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}




@end
