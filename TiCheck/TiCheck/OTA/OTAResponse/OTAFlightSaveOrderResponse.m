//
//  OTAFlightSaveOrderResponse.m
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightSaveOrderResponse.h"
#import "GDataXMLNode.h"

@implementation OTAFlightSaveOrderResponse

- (id)initWithOTASaveOrderResponse:(NSString *)xml
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
    NSArray *data = [root nodesForXPath:@"//ctrip:FlightSaveOrderResponse"
                             namespaces:self.namespacesDic
                                  error:nil];
    GDataXMLElement *saveOrderResponse = [data objectAtIndex:0];
//    GDataXMLElement *saveOrderResponse = [[root nodesForXPath:@"//ctrip:FltSaveOrderResponse"
//                                                   namespaces:self.namespacesDic
//                                                        error:nil] objectAtIndex:0];
    //int i = 1;
    // Parsing Reuslt
    _result = [ObjectElementToString(saveOrderResponse, @"Result") boolValue];
    
    // Get resultMsg
    if (_result) _resultMsg = @"提交成功";
    else _resultMsg = @"提交失败";
    
    // Parse TempOrderID
    _tempOrderID = ObjectElementToString(saveOrderResponse, @"TempOrderID");
    
    // Parse OrderID
    _orderID = ObjectElementToString(saveOrderResponse, @"OrderID");
}

@end
