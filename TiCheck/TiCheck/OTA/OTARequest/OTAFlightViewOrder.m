//
//  OTAFlightViewOrder.m
//  Test
//
//  Created by Boyi on 3/11/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightViewOrder.h"
#import "ConfigurationHelper.h"

@implementation OTAFlightViewOrder

- (NSString *)generateOTAFlightViewOrderXMLRequest
{
    NSString *header = [[ConfigurationHelper sharedConfigurationHelper] getHeaderStringWithRequestType:FlightViewOrderRequest];
    NSString *requestXML = [NSString stringWithFormat:
                            @"&lt;Request&gt;\n"
                            "%@"
                            "&lt;/Request&gt;", [header stringByAppendingString:[self generateViewOrderListRequestXML]]];
    
    NSLog(@"request XML = %@", requestXML);
    return requestXML;
}

- (NSString *)generateViewOrderListRequestXML
{
    // TODO: 添加UID
    NSString *userID = @"";
    
    // 初始化order列表
    NSString *orderIDs = @"";
    if (_orderIDs != nil && [_orderIDs count] != 0) {
        for (NSString *order in _orderIDs) {
            [orderIDs stringByAppendingFormat:@"&lt;int&gt;%@&lt;/int&gt;\n", order];
        }
    }
    NSString *orderIDList = [NSString stringWithFormat:
                             @"&lt;FltViewOrderRequest&gt;\n"
                             "&lt;UserID&gt;%@&lt;/UserID&gt;\n"
                             "&lt;OrderID&gt;\n"
                             "%@"
                             "&lt;/OrderID&gt;\n"
                             "&lt;/FltViewOrderRequest&gt;\n", userID, orderIDs];
    return orderIDList;
}

@end
