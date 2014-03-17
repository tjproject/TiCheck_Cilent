//
//  OTAGetStatusChangedOrders.m
//  Test
//
//  Created by Boyi on 3/11/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAGetStatusChangedOrders.h"
#import "ConfigurationHelper.h"
#import "NSString+DateFormat.h"
#import "NSDate-Utilities.h"

@implementation OTAGetStatusChangedOrders

- (NSString *)generateOTAGetStatusChangedOrdersXMLRequest
{
    NSString *header = [[ConfigurationHelper sharedConfigurationHelper] getHeaderStringWithRequestType:FlightStatusChangedOrdersRequest];
    NSString *requestXML = [NSString stringWithFormat:
                            @"&lt;Request&gt;\n"
                            "%@"
                            "&lt;/Request&gt;", [header stringByAppendingString:[self generateGetStatusChangedOrdersRequestXML]]];
    
    NSLog(@"request XML = %@", requestXML);
    return requestXML;
}

- (NSString *)generateGetStatusChangedOrdersRequestXML
{
    if ([_changedTime daysBeforeDate:[NSDate date]] > 30) {
        _changedTime = [NSDate dateWithDaysBeforeNow:30];
    }
    
    NSString *getStatusChangedOrdersRequest = [NSString stringWithFormat:
                                               @"&lt;GetStatusChangedOrdersRequest&gt;\n"
                                               "&lt;ChangedTime&gt;%@&lt;/ChangedTime&gt;\n"
                                               "&lt;/GetStatusChangedOrdersRequest&gt;\n", [NSString stringFormatWithTime:_changedTime]];
    
    return getStatusChangedOrdersRequest;
}

@end
