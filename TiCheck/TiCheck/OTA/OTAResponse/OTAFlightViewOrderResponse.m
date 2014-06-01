//
//  OTAFlightViewOrderResponse.m
//  Test
//
//  Created by Boyi on 3/17/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightViewOrderResponse.h"
#import "GDataXMLNode.h"
#import "Order.h"
#import "Flight.h"
#import "Passenger.h"
#import "DeliverInfo.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"
#import "CoreData+MagicalRecord.h"

#define NO_CORRESPONDING_ORDERS_RESULT_NO @"1205002"

@implementation OTAFlightViewOrderResponse

- (id)initWithOTAFlightViewOrderResponse:(NSString *)xml
{
    if (self = [super initHeaderWithResponse:xml]) {
        if ([[self.header valueForKey:@"ResultCode"] isEqualToString:@"Success"]) {
            [self parseResponseXML:xml];
        }
    }
    
    return self;
}

- (BOOL)hasOrderRecord
{
    NSString *resultNo = [self.header valueForKey:@"ResultNo"];
    if ([resultNo isEqualToString:NO_CORRESPONDING_ORDERS_RESULT_NO]) {
        return false;
    } else {
        return true;
    }
}

- (void)parseResponseXML:(NSString *)xml
{
    GDataXMLElement *root = [self getRootElement:xml];
    
    // Parsing Result
    GDataXMLElement *resultElem = [[root nodesForXPath:@"//ctrip:Result"
                                            namespaces:self.namespacesDic
                                                 error:nil] objectAtIndex:0];
    _result = [resultElem stringValue];
    
    // Parsing ResultMessage
    GDataXMLElement *resultMsgElem = [[root nodesForXPath:@"//ctrip:ResultMessage"
                                               namespaces:self.namespacesDic
                                                    error:nil] objectAtIndex:0];
    _resultMessage = [resultMsgElem stringValue];
    
    // Parsing Orders
    NSArray *flightOrderList = [root nodesForXPath:@"//ctrip:OrderInfo"
                                        namespaces:self.namespacesDic
                                             error:nil];
    NSMutableArray *tempOrderList = [NSMutableArray array];
    for (GDataXMLElement *orderElem in flightOrderList) {
        [tempOrderList addObject:[self createOrderViaXmlElement:orderElem]];
    }
    _ordersInfoList = tempOrderList;
    
    // Parsing FailedOrder
    NSArray *failedOrderList = [root nodesForXPath:@"//ctrip:FailedOrder/*"
                                        namespaces:self.namespacesDic
                                             error:nil];
    NSMutableArray *tempFailedOrders = [NSMutableArray array];
    for (GDataXMLElement *failedOrder in failedOrderList) {
        [tempFailedOrders addObject:[failedOrder stringValue]];
    }
    _failedOrderList = tempFailedOrders;
}

- (Order *)createOrderViaXmlElement:(GDataXMLElement *)orderElement
{
    Order *flightOrder = [[Order alloc] init];
    
    // Parsing BasicOrderInfo
    GDataXMLElement *basicOrderInfo = [[orderElement nodesForXPath:@"//ctrip:BasicOrderInfo"
                                                        namespaces:self.namespacesDic
                                                             error:nil] objectAtIndex:0];
    flightOrder.orderTime        = [NSString timeFormatWithString:ObjectElementToString(basicOrderInfo, @"OrderDate")];
    flightOrder.OrderID          = ObjectElementToString(basicOrderInfo, @"OrderID");
    flightOrder.orderDesc        = ObjectElementToString(basicOrderInfo, @"OrderDesc");
    flightOrder.orderStatus      = [NSString orderStatusFromString:ObjectElementToString(basicOrderInfo, @"OrderStatus")];
    flightOrder.amount           = [ObjectElementToString(basicOrderInfo, @"Amount") integerValue];
    flightOrder.emoney           = [ObjectElementToString(basicOrderInfo, @"Emoney") integerValue];
    flightOrder.actualAmount     = [ObjectElementToString(basicOrderInfo, @"ActualAmount") integerValue];
    flightOrder.cCardPayFee      = [ObjectElementToString(basicOrderInfo, @"CCardPayFee") floatValue];
    flightOrder.serverFee        = [ObjectElementToString(basicOrderInfo, @"ServerFee") floatValue];
    flightOrder.processStatus    = [ObjectElementToString(basicOrderInfo, @"ProcessStatus") integerValue];
    flightOrder.sendTicketFee    = [ObjectElementToString(basicOrderInfo, @"SendTicketFee") integerValue];
    flightOrder.flightWay        = [NSString flightSearchTypeFromString:ObjectElementToString(basicOrderInfo, @"FlightWay")];
    flightOrder.sendTicketCityID = [ObjectElementToString(basicOrderInfo, @"SendTicketCity") integerValue];
    flightOrder.getTicketWay     = ObjectElementToString(basicOrderInfo, @"GetTicketWay");
    flightOrder.eAccountAmount   = [ObjectElementToString(basicOrderInfo, @"EAccountAmount") integerValue];
    flightOrder.persons          = [ObjectElementToString(basicOrderInfo, @"Persons") integerValue];
    flightOrder.insuranceFee     = [ObjectElementToString(basicOrderInfo, @"InsuranceFee") integerValue];
    flightOrder.isEnglish        = [ObjectElementToString(basicOrderInfo, @"IsEnglish") boolValue];
    flightOrder.flightOrderClass = [NSString flightOrderClassFromString:ObjectElementToString(basicOrderInfo, @"FlightOrderClass")];
    
    // Parsing Flights
    NSArray *flightsList = [orderElement nodesForXPath:@"//ctrip:OrderFlight"
                                            namespaces:self.namespacesDic
                                                 error:nil];
    NSMutableArray *tempFlights = [NSMutableArray array];
    for (GDataXMLElement *flightElem in flightsList) {
        [tempFlights addObject:[self createFlightViaXMLElement:flightElem]];
    }
    flightOrder.flightsList = tempFlights;
    
    // Parsing Passengers
    NSArray *passengersList = [orderElement nodesForXPath:@"//ctrip:OrderPassenger"
                                               namespaces:self.namespacesDic
                                                    error:nil];
    NSMutableArray *tempPassengers = [NSMutableArray array];
    for (GDataXMLElement *passengerElem in passengersList) {
        [tempPassengers addObject:[self createPassengerViaXMLElement:passengerElem]];
    }
    flightOrder.passengersList = tempPassengers;
    
    // Parsing Deliver
    GDataXMLElement *deliverElem = [[orderElement nodesForXPath:@"//ctrip:Deliver"
                                                     namespaces:self.namespacesDic
                                                          error:nil] objectAtIndex:0];
    DeliverInfo *deliverInfo     = [[DeliverInfo alloc] init];
    deliverInfo.deliveryTypeName = ObjectElementToString(deliverElem, @"DeliverTypeName");
    deliverInfo.deliverTimeStr   = ObjectElementToString(deliverElem, @"DeliverTime");
    deliverInfo.address          = ObjectElementToString(deliverElem, @"DeliverAddress");
    deliverInfo.city             = ObjectElementToString(deliverElem, @"DeliverCity");
    deliverInfo.canton           = ObjectElementToString(deliverElem, @"DeliverDistricts");
    deliverInfo.deliverFeeStr    = ObjectElementToString(deliverElem, @"DeliverFee");
    deliverInfo.prePayType       = ObjectElementToString(deliverElem, @"PrePayType");
    deliverInfo.prepayTypeName   = ObjectElementToString(deliverElem, @"PrepayTypeName");
    deliverInfo.contactName      = ObjectElementToString(deliverElem, @"ContactName");
    deliverInfo.contactPhone     = ObjectElementToString(deliverElem, @"ContactPhone");
    deliverInfo.contactMobile    = ObjectElementToString(deliverElem, @"ContactMobile");
    deliverInfo.contactEmail     = ObjectElementToString(deliverElem, @"ContactEmail");
    deliverInfo.sendTicketETime  = [NSString timeFormatWithString:ObjectElementToString(deliverElem, @"SendTicketETime")];
    deliverInfo.sendTicketLTime  = [NSString timeFormatWithString:ObjectElementToString(deliverElem, @"SendTicketLTime")];
    deliverInfo.getTicketWay     = ObjectElementToString(deliverElem, @"GetTicketWay");

    // Parsing StopsInfo
    flightOrder.stopsInfo        = ObjectElementToString(orderElement, @"StopsInfo");

    // Parsing Prompts
    flightOrder.promopts         = [[[orderElement nodesForXPath:@" //ctrip:Prompts/ctrip:string"
                                              namespaces:self.namespacesDic
                                                   error:nil] objectAtIndex:0] stringValue];
    
    return flightOrder;
}

- (Flight *)createFlightViaXMLElement:(GDataXMLElement *)flightElement
{
    Flight *flight = [[Flight alloc] init];
    
    flight.flightNumber                   = ObjectElementToString(flightElement, @"Flight");
    flight.airlineDibitCode                    = ObjectElementToString(flightElement, @"AirlineCode");
    flight.airlineName                    = ObjectElementToString(flightElement, @"AirLineName");
    flight.departCityID                   = [ObjectElementToString(flightElement, @"DCityID") integerValue];
    flight.departCityCode                 = ObjectElementToString(flightElement, @"DCityCode");
    flight.departCityName                 = ObjectElementToString(flightElement, @"DCityName");
    flight.arriveCityID                   = [ObjectElementToString(flightElement, @"ACityID") integerValue];
    flight.arriveCityCode                 = ObjectElementToString(flightElement, @"ACityCode");
    flight.arriveCityName                 = ObjectElementToString(flightElement, @"ACityName");
    flight.departPortCode                 = ObjectElementToString(flightElement, @"DPortCode");
    flight.departPortName                 = ObjectElementToString(flightElement, @"DPortName");
    flight.arrivePortCode                 = ObjectElementToString(flightElement, @"APortCode");
    flight.arrivePortName                 = ObjectElementToString(flightElement, @"APortName");
    flight.takeOffTime                    = [NSString timeFormatWithString:ObjectElementToString(flightElement, @"TakeOffTime")];
    flight.arrivalTime                    = [NSString timeFormatWithString:ObjectElementToString(flightElement, @"ArrivalTime")];
    flight.classGrade                     = [NSString classGradeFromString:ObjectElementToString(flightElement, @"Class")];
    flight.classGradeName                 = ObjectElementToString(flightElement, @"ClassName");
    flight.ageType                        = [NSString ageTypeFromString:ObjectElementToString(flightElement, @"AgeType")];
    flight.nonRer                         = ObjectElementToString(flightElement, @"NonRer");
    flight.rerNote                        = ObjectElementToString(flightElement, @"RerNotes");
    flight.nonRef                         = ObjectElementToString(flightElement, @"NonRef");
    flight.refNote                        = ObjectElementToString(flightElement, @"RefNotes");
    flight.nonEnd                         = ObjectElementToString(flightElement, @"NonEnd");
    flight.endNote                        = ObjectElementToString(flightElement, @"EndNotes");
    flight.remarks                        = ObjectElementToString(flightElement, @"Remark");
    flight.price                          = [ObjectElementToString(flightElement, @"Price") integerValue];
    flight.rate                           = [ObjectElementToString(flightElement, @"PriceRate") floatValue];
    flight.adultTax                       = [ObjectElementToString(flightElement, @"Tax") integerValue];
    flight.adultOilFee                    = [ObjectElementToString(flightElement, @"OilFee") integerValue];
    flight.amount                         = [ObjectElementToString(flightElement, @"Amount") floatValue];
    flight.standardPrice                  = [ObjectElementToString(flightElement, @"StandardPrice") integerValue];
    flight.ticketType                     = ObjectElementToString(flightElement, @"TicketTypeName");
    flight.routeIndex                     = [ObjectElementToString(flightElement, @"Sequence") integerValue];
    flight.hasAirportBuildingInformation  = [ObjectElementToString(flightElement, @"HasAirportBuildingInformation") boolValue];
    flight.isSurface                      = [ObjectElementToString(flightElement, @"IsSurface") boolValue];
    flight.checkInTime                    = [NSString timeFormatWithString:ObjectElementToString(flightElement, @"CheckInTime")];
    flight.craftType                      = ObjectElementToString(flightElement, @"CraftType");
    flight.serverFee                      = [ObjectElementToString(flightElement, @"ServerFee") floatValue];

    GDataXMLElement *departAirportElement = [[flightElement elementsForName:@"DepartAirport"] objectAtIndex:0];
    GDataXMLElement *arriveAirportElement = [[flightElement elementsForName:@"ArriveAirport"] objectAtIndex:0];

    flight.departPortBuildingID           = [ObjectElementToString(departAirportElement, @"ID") integerValue];
    flight.arrivePortAddress              = ObjectElementToString(arriveAirportElement, @"Address");
    flight.arrivePortBuildingID           = [ObjectElementToString(arriveAirportElement, @"ID") integerValue];
    flight.arrivePortBuildingName         = ObjectElementToString(arriveAirportElement, @"Name");
    flight.arrivePortBuildingShortName    = ObjectElementToString(arriveAirportElement, @"Shortname");
    flight.arrivePortSMSName              = ObjectElementToString(arriveAirportElement, @"SMSName");
    
    return flight;
}

- (Passenger *)createPassengerViaXMLElement:(GDataXMLElement *)passengerElement
{
    Passenger *passenger = [Passenger MR_createEntity];
    
    passenger.passengerName   = ObjectElementToString(passengerElement, @"PassengerName");
    passenger.birthDay        = [NSString timeFormatWithString:ObjectElementToString(passengerElement, @"Birthday")];
    passenger.gender          = [NSNumber numberWithInteger:[NSString genderFromString:ObjectElementToString(passengerElement, @"Gender")]];
    passenger.nationalityCode = ObjectElementToString(passengerElement, @"NationalityCode");
    passenger.nationalityName = ObjectElementToString(passengerElement, @"NationalityName");
    passenger.cardTypeName    = ObjectElementToString(passengerElement, @"CardTypeName");
    passenger.passportNumber  = ObjectElementToString(passengerElement, @"CardTypeNumber");
    passenger.passengerNamePY = ObjectElementToString(passengerElement, @"PassengerNamePY");
    passenger.cardValid       = [NSString timeFormatWithString:ObjectElementToString(passengerElement, @"CardValid")];
    passenger.corpEid         = ObjectElementToString(passengerElement, @"CorpEid");
    
    return passenger;
}

@end
