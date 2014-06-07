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

- (void)testCreateUserFormat
{
    NSDictionary *result = [_server createUserWithEmail:@"aaa" password:@"asdfghjkl" account:nil uniqueID:nil];
    NSLog(@"returned dictionary: %@", result);
    XCTAssertEqual([result[@"Code"] integerValue], 3, @"meesage returned wrongly");
}

@end
