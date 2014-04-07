//
//  UserUniqueIDTest.m
//  TiCheck
//
//  Created by Boyi on 3/31/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OTAUserUniqueID.h"
#import "OTAUserUniqueIDResponse.h"
#import "SoapRequest.h"
#import "ConfigurationHelper.h"

@interface UserUniqueIDTest : XCTestCase

@end

@implementation UserUniqueIDTest

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

- (void)testUserGenerateSync
{
    OTAUserUniqueID *userUniqueID = [[OTAUserUniqueID alloc] initWithUserName:@"boylee1111@sina.com" telNumber:@"18602166978"];
    NSString *userRequest = [userUniqueID generateOTAUserUniqueIDXMLRequest];
    
    NSString *responseXML = [SoapRequest getSoap12WebServiceResponseWithURL:API_URL
                                                          flightRequestType:UserUniqueID
                                                               xmlNameSpace:XML_NAME_SPACE
                                                             webServiceName:WEB_SERVICE_NAME
                                                             xmlRequestBody:userRequest];
    NSLog(@"reponse = %@", responseXML);
    XCTAssertNotNil(responseXML, @"reponse not nil");
    
    OTAUserUniqueIDResponse *userUniqueReponse = [[OTAUserUniqueIDResponse alloc] initWithOTAUserUniqueIDResponse:responseXML];
    XCTAssertNotNil(userUniqueReponse.uniqueUID, @"unique UID not nil");
    XCTAssertEqual(userUniqueReponse.retCode, (NSUInteger)0, "ret code success");
}

@end
