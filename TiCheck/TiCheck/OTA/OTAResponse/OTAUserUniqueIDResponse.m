//
//  OTAUserUniqueIDResponse.m
//  Test
//
//  Created by Boyi on 3/17/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAUserUniqueIDResponse.h"
#import "GDataXMLNode.h"

@implementation OTAUserUniqueIDResponse

- (id)initWithOTAUserUniqueIDResponse:(NSString *)xml
{
    if (self = [super initHeaderWithResponse:xml]) {
        if ([[self.header valueForKey:@"ResultCode"] isEqualToString:@"Success"]) {
            [self parseResponseXML:xml];
        }
    }
    
    return self;
}

- (void)parseResponseXML:(NSString *)xml
{
    GDataXMLElement *root = [self getRootElement:xml];
    
    // Parsing UniqueUID
    GDataXMLElement *userReponseElem = [[root nodesForXPath:@"//ctrip:UserResponse"
                                               namespaces:self.namespacesDic
                                                    error:nil] objectAtIndex:0];
    
    _uniqueUID = ObjectElementToString(userReponseElem, @"UniqueUID");
    _operationType = [ObjectElementToString(userReponseElem, @"OperationType") integerValue];
    _retCode = [ObjectElementToString(userReponseElem, @"RetCode") integerValue];
}

@end
