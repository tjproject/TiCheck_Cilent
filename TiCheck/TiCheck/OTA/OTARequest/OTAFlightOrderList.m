//
//  OTAFlightOrderList.m
//  Test
//
//  Created by Boyi on 3/10/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightOrderList.h"
#import "ConfigurationHelper.h"
#import "NSString+DateFormat.h"

@implementation OTAFlightOrderList

- (NSString *)generateOTAFlightOrderListXMLRequest
{
    NSString *header = [[ConfigurationHelper sharedConfigurationHelper] getHeaderStringWithRequestType:FlightOrderListRequest];
    NSString *requestXML = [NSString stringWithFormat:
                            @"&lt;Request&gt;"
                            "%@"
                            "&lt;/Request&gt;", [header stringByAppendingString:[self generateOrderListRequestXML]]];
    
    NSLog(@"request XML = %@", requestXML);
    return requestXML;
}

- (NSString *)generateOrderListRequestXML
{
    NSString *userID           = _uniqueUID;
    
    NSString *effectDate       = [NSString stringWithFormat:@"&lt;EffectDate&gt;%@&lt;/EffectDate&gt;", [NSString stringFormatWithTime:_effectDate]];
    NSString *expiryDate       = [NSString stringWithFormat:@"&lt;ExpiryDate&gt;%@&lt;/ExpiryDate&gt;", [NSString stringFormatWithTime:_expiryDate]];
    NSString *orderID          = [NSString stringWithFormat:@"&lt;OrderID&gt;%@&lt;/OrderID&gt;", _orderID];
    NSString *orderStatus      = [NSString stringWithFormat:@"&lt;OrderStatus&gt;%lu&lt;/OrderStatus&gt;", _orderStatus];
    NSString *topCount         = [NSString stringWithFormat:@"&lt;TopCount&gt;%ld&lt;/TopCount&gt;", _topCount];
    NSString *orderType        = [NSString stringWithFormat:@"&lt;OrderType&gt;D&lt;/OrderType&gt;"];

    NSString *orderListRequest = [NSString stringWithFormat:
                                  @"&lt;FltOrderListRequest&gt;\n"
                                  "&lt;UserID&gt;%@&lt;/UserID&gt;\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "%@\n"
                                  "&lt;/FltOrderListRequest&gt;", userID, effectDate, expiryDate, orderID, orderStatus, topCount, orderType];
    
    return orderListRequest;
}

@end
