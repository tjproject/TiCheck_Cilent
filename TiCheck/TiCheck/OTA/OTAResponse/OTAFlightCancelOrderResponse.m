//
//  OTAFlightCancelOrderResponse.m
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightCancelOrderResponse.h"
#import "GDataXMLNode.h"

@implementation OTAFlightCancelOrderResponse

- (id)initWithOTAFlightCancelOrderResponse:(NSString *)xml
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
    GDataXMLElement *cancelOrderResponse = [[root nodesForXPath:@"//ctrip:FltCancelOrderResponse"
                                                     namespaces:self.namespacesDic
                                                          error:nil] objectAtIndex:0];
    
    // Parsing Result
    _result = [ObjectElementToString(cancelOrderResponse, @"Result") boolValue];
    
    // Parsing Message
    _message = ObjectElementToString(cancelOrderResponse, @"Message");
}

@end
