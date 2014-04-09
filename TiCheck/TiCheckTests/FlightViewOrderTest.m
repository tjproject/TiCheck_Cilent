//
//  FlightViewOrderTest.m
//  TiCheck
//
//  Created by Boyi on 4/7/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConfigurationHelper.h"
#import "SoapRequest.h"
#import "OTAFlightViewOrder.h"
#import "OTAFlightViewOrderResponse.h"

@interface FlightViewOrderTest : XCTestCase

@end

@implementation FlightViewOrderTest

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

- (void)testFlightViewOrderSync
{
    OTAFlightViewOrder *flightViewOrder = [[OTAFlightViewOrder alloc] initWithUserUniqueUID:TEMPORARY_UNIQUE_UID
                                                                                 orderLists:[NSArray arrayWithObjects:@"1016648971", nil]];
    NSString *requestXML = [flightViewOrder generateOTAFlightViewOrderXMLRequest];
    NSString *responseXML = [SoapRequest getSoap12WebServiceResponseWithURL:API_URL
                                                          flightRequestType:FlightViewOrderRequest
                                                               xmlNameSpace:XML_NAME_SPACE
                                                             webServiceName:WEB_SERVICE_NAME
                                                             xmlRequestBody:requestXML];
    XCTAssertNotNil(responseXML, "not nil");
//    NSLog(@"request XML = %@\nresponse XML = %@", requestXML, responseXML);
    
    OTAFlightViewOrderResponse *flightViewOrderResponse = [[OTAFlightViewOrderResponse alloc] initWithOTAFlightViewOrderResponse:responseXML];
    
    [flightViewOrderResponse hasOrderRecord] ? NSLog(@"has order") : NSLog(@"no order");
}

@end
