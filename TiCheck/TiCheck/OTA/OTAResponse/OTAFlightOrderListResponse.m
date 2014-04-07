//
//  OTAFlightOrderListResponse.m
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightOrderListResponse.h"
#import "GDataXMLNode.h"
#import "Order.h"
#import "Flight.h"
#import "NSString+EnumTransform.h"
#import "NSString+DateFormat.h"

@implementation OTAFlightOrderListResponse

- (id)initWithOTAFlightOrderListResponse:(NSString *)xml
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
    
    // Parsing RecordsCount
    GDataXMLElement *recordCount = [[root nodesForXPath:@"//ctrip:RecordsCount"
                                             namespaces:self.namespacesDic
                                                  error:nil] objectAtIndex:0];
    _recordsCount = [[recordCount stringValue] integerValue];
    
    // Parsing Orders
    NSArray *flightOrderList = [root nodesForXPath:@"//ctrip:FltOrder"
                                        namespaces:self.namespacesDic
                                             error:nil];
    NSMutableArray *tempOrderList = [NSMutableArray array];
    for (GDataXMLElement *orderElem in flightOrderList) {
        [tempOrderList addObject:[self createFlightOrderViaXMLElement:orderElem]];
    }
    _orderList = tempOrderList;
}

- (Order *)createFlightOrderViaXMLElement:(GDataXMLElement *)orderElement
{
    Order *flightOrder = [[Order alloc] init];
    
    // Parsing Flights
    NSArray *flights = [orderElement nodesForXPath:@"//ctrip:OrderListFlight"
                                 namespaces:self.namespacesDic
                                      error:nil];
    NSMutableArray *tempFlights = [NSMutableArray array];
    for (GDataXMLElement *flightElem in flights) {
        [tempFlights addObject:[self createFlightViaXMLElement:flightElem]];
    }
    flightOrder.flightsList = tempFlights;
    
    // Parsing Other Info of FlightOrder
    flightOrder.sendTicketCity = ObjectElementToString(orderElement, @"SendTicketCity");
    flightOrder.flightWay      = [NSString flightSearchTypeFromString:ObjectElementToString(orderElement, @"FlightWay")];
    flightOrder.OrderID        = ObjectElementToString(orderElement, @"OrderID");
    flightOrder.orderTime      = [NSString timeFormatWithString:ObjectElementToString(orderElement, @"OrderTime")];
    flightOrder.orderDesc      = ObjectElementToString(orderElement, @"OrderDesc");
    flightOrder.orderStatus    = [NSString orderStatusFromString:ObjectElementToString(orderElement, @"OrderStatus")];
    flightOrder.amount         = [ObjectElementToString(orderElement, @"Amount") integerValue];
    
    return flightOrder;
}

- (Flight *)createFlightViaXMLElement:(GDataXMLElement *)flightElement
{
    Flight *flight = [[Flight alloc] init];
    
    // Parsing Info of Flight
    flight.flightNumber   = ObjectElementToString(flightElement, @"Flight");
    flight.departCityCode = ObjectElementToString(flightElement, @"DCityCode");
    flight.departCityName = ObjectElementToString(flightElement, @"DCityName");
    flight.departPortCode = ObjectElementToString(flightElement, @"DPortCode");
    flight.arriveCityCode = ObjectElementToString(flightElement, @"ACityCode");
    flight.arriveCityName = ObjectElementToString(flightElement, @"ACityName");
    flight.arrivePortCode = ObjectElementToString(flightElement, @"APortCode");
    flight.takeOffTime    = [NSString timeFormatWithString:ObjectElementToString(flightElement, @"TakeOffTime")];
    flight.arrivalTime    = [NSString timeFormatWithString:ObjectElementToString(flightElement, @"ArrivalTime")];
    flight.routeIndex     = [ObjectElementToString(flightElement, @"Sequence") integerValue];
    
    return flight;
}

@end
