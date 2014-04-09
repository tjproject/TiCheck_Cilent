//
//  OTAGetStatusChangedOrdersResponse.m
//  Test
//
//  Created by Boyi on 3/17/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAGetStatusChangedOrdersResponse.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"
#import "GDataXMLNode.h"
#import "Order.h"

@implementation OTAGetStatusChangedOrdersResponse

- (id)initWithOTAGetStatusChangedOrdersResponse:(NSString *)xml
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
    
    // Parsing RecordCount
    GDataXMLElement *recordCountElem = [[root nodesForXPath:@"//ctrip:RecordsCount"
                                                 namespaces:self.namespacesDic
                                                      error:nil] objectAtIndex:0];
    _recordCount = [[recordCountElem stringValue] integerValue];
    
    // Parsing ChangedOrder
    NSArray *changedOrdersList = [root nodesForXPath:@"//ctrip:ChangedOrder" namespaces:self.namespacesDic error:nil];
    NSMutableArray *tempChangedOrders = [NSMutableArray array];
    for (GDataXMLElement *changedOrderElem in changedOrdersList) {
        [tempChangedOrders addObject:[self createOrderViaXmlElement:changedOrderElem]];
    }
    _changedOrders = tempChangedOrders;
}

- (Order *)createOrderViaXmlElement:(GDataXMLElement *)orderElement
{
    Order *order = [[Order alloc] init];
    
    order.OrderID = ObjectElementToString(orderElement, @"OrderID");
    order.orderTime = [NSString timeFormatWithString:ObjectElementToString(orderElement, @"CreatedTime")];
    order.latestChangedTime = [NSString timeFormatWithString:ObjectElementToString(orderElement, @"LastestChangedTime")];
    order.orderStatus = [NSString orderStatusFromString:ObjectElementToString(orderElement, @"OrderStatus")];
    
    return order;
}

@end
