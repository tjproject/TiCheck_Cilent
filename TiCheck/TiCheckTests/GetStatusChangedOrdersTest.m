//
//  GetStatusChangedOrdersTest.m
//  TiCheck
//
//  Created by Boyi on 4/7/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SoapRequest.h"
#import "ConfigurationHelper.h"
#import "OTAGetStatusChangedOrders.h"
#import "OTAGetStatusChangedOrdersResponse.h"

@interface GetStatusChangedOrdersTest : XCTestCase

@end

@implementation GetStatusChangedOrdersTest

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

- (void)testGetStatusChangedOrdersSync
{
    OTAGetStatusChangedOrders *getStatusChangedOrders = [[OTAGetStatusChangedOrders alloc] initWithChangedTime:[NSDate date]];
    NSString *requestXML = [getStatusChangedOrders generateOTAGetStatusChangedOrdersXMLRequest];
    NSString *responseXML = [SoapRequest getSoap12WebServiceResponseWithURL:API_URL
                                                          flightRequestType:FlightStatusChangedOrdersRequest
                                                               xmlNameSpace:XML_NAME_SPACE
                                                             webServiceName:WEB_SERVICE_NAME
                                                             xmlRequestBody:requestXML];
    XCTAssertNotNil(responseXML, @"not nil");
    NSLog(@"response XML = %@", responseXML);
    
    OTAGetStatusChangedOrdersResponse *getStatusChangedOrdersResponse = [[OTAGetStatusChangedOrdersResponse alloc] initWithOTAGetStatusChangedOrdersResponse:responseXML];
    XCTAssertEqual(getStatusChangedOrdersResponse.recordCount, [getStatusChangedOrdersResponse.changedOrders count], @"result equal");
}

@end
