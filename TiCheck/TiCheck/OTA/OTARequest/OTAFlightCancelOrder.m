//
//  OTAFlightCancelOrder.m
//  Test
//
//  Created by Boyi on 3/10/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightCancelOrder.h"
#import "ConfigurationHelper.h"

@implementation OTAFlightCancelOrder

- (NSString *)generateOTAFlightCancelOrderXMLRequest
{
    NSString *header = [[ConfigurationHelper sharedConfigurationHelper] getHeaderStringWithRequestType:FlightCancelOrderRequest];
    NSString *requestXML = [NSString stringWithFormat:
                            @"<Request&gt;\n"
                            "%@"
                            "</Request&gt;", [header stringByAppendingString:[self generateCancelOrderListRequestXML]]];
    
    return requestXML;
}

- (NSString *)generateCancelOrderListRequestXML
{
    NSString *userID = _uniqueUID;

    // 初始化order列表
    NSString *orderIDs = @"";
    if (_orderIDs != nil && [_orderIDs count] != 0) {
        for (NSString *order in _orderIDs) {
            [orderIDs stringByAppendingFormat:@"<int&gt;%@</int&gt;\n", order];
        }
    }
    NSString *orderIDList = [NSString stringWithFormat:
                             @"<FltCancelOrderRequest&gt;\n"
                             "<UserID&gt;%@</UserID&gt;"
                             "<OrderID&gt;\n"
                             "%@"
                             "</OrderID&gt;\n"
                             "</FltCancelOrderRequest&gt;\n", userID, orderIDs];
    return orderIDList;
}

@end
