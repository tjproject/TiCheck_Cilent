//
//  PassengerHelperTest.m
//  TiCheck
//
//  Created by Boyi on 6/1/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConfigurationHelper.h"
#import "Passenger.h"
#import "PassengerEntity.h"
#import "EnumCollection.h"

@interface PassengerHelperTest : XCTestCase

@end

@implementation PassengerHelperTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[ConfigurationHelper sharedConfigurationHelper] resetAll];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    for (int i = 0; i < 10; ++i) {
        // 插10个
    Passenger *pe = [Passenger passengerWithPassengerName:[NSString stringWithFormat:@"Passenger + %d", i]  birthday:[NSDate date] passportType:Passport passportNo:[NSString stringWithFormat:@"%d%d%d%d%d", i, i, i, i, i]];
        [pe savePassenger];
    }
    
    // 查所有检验
    NSArray *all = [Passenger findAllPassengers];
    XCTAssertEqual(all.count, 10, @"equal");
    
    // 查不存在
    Passenger *passenger = [Passenger findPassengerWithPassengerName:@"DSADSA"];
    XCTAssertNil(passenger, @"not fount");
    
    // 查存在
    passenger = [Passenger findPassengerWithPassengerName:@"Passenger + 2"];
    XCTAssertNotNil(passenger, @"find");
    
    // 改存在
    passenger.passportNumber = @"DSAKJDSAKLJDSDA";
    [passenger savePassenger];
    
    // 检验改成功
    passenger = [Passenger findPassengerWithPassengerName:@"Passenger + 2"];
    XCTAssertEqualObjects(passenger.passportNumber, @"DSAKJDSAKLJDSDA", @"equal");
    
    // 删一个检验
    [passenger deletePassenger];
    all = [Passenger findAllPassengers];
    XCTAssertEqual(all.count, 9, @"equal");
    
    // 删所有检验
    [Passenger deleteAllPassengers];
    all = [Passenger findAllPassengers];
    XCTAssertEqual(all.count, 0, @"empty");
}

@end
