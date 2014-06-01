//
//  FlightSaveOrderTest.m
//  TiCheck
//
//  Created by Boyi on 4/6/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SoapRequest.h"
#import "ConfigurationHelper.h"
#import "Flight.h"
#import "Passenger.h"
#import "Contact.h"
#import "DeliverInfo.h"
#import "OTAFlightSearch.h"
#import "OTAFlightSearchResponse.h"
#import "OTAFlightSaveOrder.h"
#import "OTAFlightSaveOrderResponse.h"
#import "NSString+DateFormat.h"
#import "NSDate-Utilities.h"

@interface FlightSaveOrderTest : XCTestCase

@end

@implementation FlightSaveOrderTest

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

- (void)testFlightSaveOrderSync
{
    OTAFlightSearch *flightSearch = [[OTAFlightSearch alloc] init];
    flightSearch.searchType = S;
    flightSearch.departCity = @"SHA";
    flightSearch.arriveCity = @"BJS";
    flightSearch.departDate = [NSDate dateWithDaysFromNow:2];
    flightSearch.orderBy = Price;
    flightSearch.orderDirection = ASC;
    
    NSString *requestXML = [flightSearch generateOTAFlightSearchXMLRequest];
    NSString *responseXML = [SoapRequest getSoap12WebServiceResponseWithURL:API_URL
                                                          flightRequestType:FlightSearchRequest
                                                               xmlNameSpace:XML_NAME_SPACE
                                                             webServiceName:WEB_SERVICE_NAME
                                                             xmlRequestBody:requestXML];
    
//    NSLog(@"response XML = %@", requestXML);
    // 搜索结果解析，直接用返回的XML初始化即可
    OTAFlightSearchResponse *flightSearchResponse = [[OTAFlightSearchResponse alloc] initWithOTAFlightSearchResponse:responseXML];
    if (flightSearchResponse.recordCount == 0) return ;
    
    Flight *flightSample = [flightSearchResponse.flightsList firstObject];
    Passenger *passengerSample = [Passenger passengerWithPassengerName:@"邱峰"
                                                              birthday:[NSString dateFormatWithString:@"1111-11-11"]
                                                          passportType:ID
                                                            passportNo:@"342921198707062115"];
    Contact *contactSample = [Contact contactWithContactName:@"邱峰"
                                               confirmOption:TEL
                                                 mobilePhone:@"13800138000"
                                                contactEmail:@"1111@sina.com"];
    OTAFlightSaveOrder *flightSaveOrder = [[OTAFlightSaveOrder alloc] initWithUserUniqueUID:TEMPORARY_UNIQUE_UID
                                                                                    AgeType:ADU
                                                                                 flightList:[NSArray arrayWithObject:flightSample]
                                                                              passengerList:[NSArray arrayWithObject:passengerSample]
                                                                                    contact:contactSample];
    NSString *saveOrderRequestXML = [flightSaveOrder generateOTAFlightSaveOrderXMLRequest];
    NSString *saveOrderResponseXML = [SoapRequest getSoap12WebServiceResponseWithURL:API_URL
                                                                   flightRequestType:FlightSaveOrderRequest
                                                                        xmlNameSpace:XML_NAME_SPACE
                                                                      webServiceName:WEB_SERVICE_NAME
                                                                      xmlRequestBody:saveOrderRequestXML];
    NSLog(@"request = %@, response = %@", saveOrderRequestXML, saveOrderResponseXML);
}

@end
