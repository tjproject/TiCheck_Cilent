//
//  FlightOrderListTest.m
//  TiCheck
//
//  Created by Boyi on 4/7/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SoapRequest.h"
#import "ConfigurationHelper.h"
#import "OTAFlightOrderList.h"
#import "OTAFlightOrderListResponse.h"
#import "NSDate-Utilities.h"

@interface FlightOrderListTest : XCTestCase

@end

@implementation FlightOrderListTest

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

- (void)testFlightOrderListSync
{
    OTAFlightOrderList *flightOrderList = [[OTAFlightOrderList alloc] initWithUserUniqueUID:TEMPORARY_UNIQUE_UID
                                                                                 effectDate:[NSDate dateWithDaysBeforeNow:3600]
                                                                                 expiryDate:[NSDate dateWithDaysFromNow:3600]
                                                                                orderStatus:AllOrders];
    NSString *requestXML = [flightOrderList generateOTAFlightOrderListXMLRequest];
    NSString *responseXML = [SoapRequest getSoap12WebServiceResponseWithURL:API_URL
                                                          flightRequestType:FlightOrderListRequest
                                                               xmlNameSpace:XML_NAME_SPACE
                                                             webServiceName:WEB_SERVICE_NAME
                                                             xmlRequestBody:requestXML];
//    NSLog(@"request XML = %@\nresponse XML = %@", requestXML, responseXML);
    XCTAssertNotNil(responseXML, "response is nil");
    
    OTAFlightOrderListResponse *flightOrderListResponse = [[OTAFlightOrderListResponse alloc] initWithOTAFlightOrderListResponse:responseXML];
//    NSLog(@"record count = %lu", (unsigned long)flightOrderListResponse.recordsCount);
    XCTAssertEqual([flightOrderListResponse.orderList count], flightOrderListResponse.recordsCount, "result not equal");
}

@end
