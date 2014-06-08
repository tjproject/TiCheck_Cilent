//
//  PrintObjectTest.m
//  TiCheck
//
//  Created by Ming Yang on 6/6/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PrintObject.h"
#import "Subscription.h"
#import "Airline.h"
#import "DomesticCity.h"

@interface PrintObjectTest : XCTestCase
@property (nonatomic, strong) Airline *airline;
@property (nonatomic, strong) Subscription *subscription;
@end

@implementation PrintObjectTest
@synthesize airline = _airline, subscription=_subscription;

- (void)setUp
{
    [super setUp];
    _airline = [[Airline alloc] init];
    _airline.airline = @"as";
    _airline.airlineCode = @"252";
    
    _subscription = [[Subscription alloc] initWithDepartCity:@"北京" arriveCity:@"上海" startDate:@"2015-11-11" endDate:@"2015-12-11"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testObject2Dictionary
{
    NSDictionary *dicAirline = [PrintObject getObjectData:_airline];
    XCTAssertNotNil(dicAirline, @"getObjectData function return nil");
    XCTAssertEqual(dicAirline[@"airline"], @"as", @"convert property into dictionary wrongly");
}

- (void)testComplexObject2Dictionary
{
    NSDictionary *dicSubscription = [PrintObject getObjectData:_subscription];
    XCTAssertEqualObjects(dicSubscription[@"arriveCity"][@"cityCode"], @"SHA", @"convert double layer complex object to dictionary failed");
}

- (void)testComplexDictionary2Object
{
    NSDictionary *dicSubscription = [PrintObject getObjectData:_subscription];

    Subscription *subscription;
    subscription = [PrintObject getObject:_subscription WithData:dicSubscription];
    
    XCTAssertEqualObjects(subscription.arriveCity.cityCode, @"SHA", @"convert complex dictionary to object fail");
}



@end
