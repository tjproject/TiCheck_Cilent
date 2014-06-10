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

- (id)initWithUserUniqueUID:(NSString *)uniqueID
                 effectDate:(NSDate *)effectDate
                 expiryDate:(NSDate *)expiryDate
                orderStatus:(OrderStatus)orderStatus
{
    if (self = [super init]) {
        _uniqueUID = uniqueID;
        _effectDate = effectDate;
        _expiryDate = expiryDate;
        _orderStatus = AllOrders;
        _orderID = @"0";
        _topCount = 0;
    }
    
    return self;
}

- (NSString *)generateOTAFlightOrderListXMLRequest
{
    NSString *header = [[ConfigurationHelper sharedConfigurationHelper] getHeaderStringWithRequestType:FlightOrderListRequest];
    NSString *requestXML = [NSString stringWithFormat:
                            @"&lt;Request&gt;"
                            "%@"
                            "&lt;/Request&gt;", [header stringByAppendingString:[self generateOrderListRequestXML]]];
    
    return requestXML;
}

- (NSString *)generateOrderListRequestXML
{
    NSString *userID           = _uniqueUID;
    
    NSString *effectDate       = [NSString stringWithFormat:@"&lt;EffectDate&gt;%@&lt;/EffectDate&gt;", [NSString stringFormatWithTime:_effectDate]];
    NSString *expiryDate       = [NSString stringWithFormat:@"&lt;ExpiryDate&gt;%@&lt;/ExpiryDate&gt;", [NSString stringFormatWithTime:_expiryDate]];
    NSString *orderID          = [NSString stringWithFormat:@"&lt;OrderID&gt;%@&lt;/OrderID&gt;", _orderID];
    NSString *orderStatus      = [NSString stringWithFormat:@"&lt;OrderStatus&gt;%u&lt;/OrderStatus&gt;", _orderStatus];
    NSString *topCount         = [NSString stringWithFormat:@"&lt;TopCount&gt;%d&lt;/TopCount&gt;", _topCount];
    NSString *orderType        = [NSString stringWithFormat:@"&lt;OrderType&gt;D&lt;/OrderType&gt;"];

    NSString *orderListRequest = [NSString stringWithFormat:
                                  @"&lt;FltOrderListRequest&gt;\n"
                                  "&lt;Uid&gt;%@&lt;/Uid&gt;\n"
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
