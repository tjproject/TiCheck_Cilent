//
//  FlightSearchTest.m
//  TiCheck
//
//  Created by Boyi on 4/1/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConfigurationHelper.h"
#import "OTAFlightSearch.h"
#import "OTAFlightSearchResponse.h"
#import "SoapRequest.h"

@interface FlightSearchTest : XCTestCase

@end

@implementation FlightSearchTest

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

- (void)testFlightSearchSych
{
    // 机票搜索同步请求
    OTAFlightSearch *flightSearch = [[OTAFlightSearch alloc] init];
    flightSearch.searchType = S;
    flightSearch.departCity = @"SHA";
    flightSearch.arriveCity = @"BJS";
    flightSearch.departDate = [NSDate date];
    flightSearch.airline = @"CA";
    flightSearch.orderBy = Price;
    flightSearch.orderDirection = ASC;
    
    NSString *requestXML = [flightSearch generateOTAFlightSearchXMLRequest];
//    NSLog(@"request XML = %@", requestXML);
    
    NSString *responseXML = [SoapRequest getSoap11WebServiceResponseWithURL:API_URL flightRequestType:FlightSearchRequest xmlNameSpace:XML_NAME_SPACE webServiceName:WEB_SERVICE_NAME xmlRequestBody:requestXML];
//    NSLog(@"response XML = %@", responseXML);
    XCTAssertNotNil(responseXML, "reponse not nil");
    
    // 搜索结果解析
    OTAFlightSearchResponse *flightSearchResponse = [[OTAFlightSearchResponse alloc] initWithOTAFlightSearchResponse:responseXML];
    XCTAssertEqual(flightSearchResponse.recordCount, flightSearchResponse.flightsList.count, "result equal");
    XCTAssertEqual(flightSearchResponse.orderBy, Price, "order by price");
    XCTAssertEqual(flightSearchResponse.orderDirection, ASC, "order asc");
}

@end
