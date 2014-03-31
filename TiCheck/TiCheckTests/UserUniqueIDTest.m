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

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testUserGenerate
{
    OTAUserUniqueID *userUniqueID = [[OTAUserUniqueID alloc] initWithUserName:@"boylee1111" telNumber:@"18347582934"];
    NSString *userRequest = [userUniqueID generateOTAUserUniqueIDXMLRequest];
    
    NSString *userResponseXML = [SoapRequest getSoap11WebServiceResponse:API_URL webServiceFile:(NSString *) xmlNameSpace:XML_NAME_SPACE webServiceName:WEB_SERVICE_NAME xmlRequestBody:userRequest];
}

@end
