//
//  OTAFlightSearchResponse.m
//  Test
//
//  Created by Boyi on 3/15/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightSearchResponse.h"
#import "NSString+EnumTransform.h"
#import "GDataXMLNode.h"
#import "NSString+DateFormat.h"
#import "Flight.h"

@implementation OTAFlightSearchResponse

- (id)initWithOTAFlightSearchResponse:(NSString *)xml
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
    NSArray *recordCountArr = [root nodesForXPath:@"//ctrip:RecordCount"
                                       namespaces:self.namespacesDic
                                            error:nil];
    // 没有符合条件的航班
    if ([recordCountArr count] == 0) {
        _recordCount = 0;
        _flightsList = [NSArray array];
        return ;
    }
    
    // 有符合条件的航班
    GDataXMLElement *recordCount = [recordCountArr objectAtIndex:0];
    _recordCount = [[recordCount stringValue] integerValue];
    
    // Parsing OrderBy
    GDataXMLElement *orderBy = [[root nodesForXPath:@"//ctrip:OrderBy"
                                         namespaces:self.namespacesDic
                                              error:nil] objectAtIndex:0];
    _orderBy = [NSString orderCriterionFromString:[orderBy stringValue]];
    
    // Parsing Direction
    GDataXMLElement *orderDirection = [[root nodesForXPath:@"//ctrip:Direction"
                                                namespaces:self.namespacesDic
                                                     error:nil] objectAtIndex:0];
    _orderDirection = [NSString orderDirectionFromString:[orderDirection stringValue]];
    
    // Parsing FlightsList
    NSArray *flightsList = [root nodesForXPath:@"//ctrip:DomesticFlightData"
                                    namespaces:self.namespacesDic
                                         error:nil];
    NSMutableArray *tempFlights = [NSMutableArray array];
    for (GDataXMLElement *flightElem in flightsList) {
        Flight *newFlight = [self createFilghtViaXMLElement:flightElem];
//        if ([tempFlights count] != 0) {
//            Flight *lastFlight = [tempFlights lastObject];
//            if (![newFlight.flightNumber isEqualToString:lastFlight.flightNumber]) {
//                [tempFlights addObject:newFlight];
//            }
//        }
//        else {
            [tempFlights addObject:newFlight];
//        }
    }
    
    // 按打折后的价格排序
//    NSSortDescriptor *priceSortDescription = [NSSortDescriptor sortDescriptorWithKey:@"_price" ascending:YES];
//    NSSortDescriptor *dateSortDescription = [NSSortDescriptor sortDescriptorWithKey:@"_takeOffTime" ascending:YES];
//    _flightsList = [tempFlights sortedArrayUsingDescriptors:[NSArray arrayWithObjects:priceSortDescription ,dateSortDescription, nil]];
    
    _flightsList = tempFlights;
}

- (Flight *)createFilghtViaXMLElement:(GDataXMLElement *)element
{
    Flight *flight = [[Flight alloc] init];
    
    flight.departCityCode          = ObjectElementToString(element, @"DepartCityCode");
    flight.arriveCityCode          = ObjectElementToString(element, @"ArriveCityCode");
    flight.takeOffTime             = [NSString timeFormatWithString:ObjectElementToString(element, @"TakeOffTime")];
    flight.arrivalTime             = [NSString timeFormatWithString:ObjectElementToString(element, @"ArriveTime")];
    flight.flightNumber            = ObjectElementToString(element, @"Flight");
    flight.craftType               = ObjectElementToString(element, @"CraftType");
    flight.airlineDibitCode             = ObjectElementToString(element, @"AirlineCode");
    flight.classGrade              = [NSString classGradeFromString:ObjectElementToString(element, @"Class")];
    flight.subClass                = ObjectElementToString(element, @"SubClass");
    flight.displaySubClass         = ObjectElementToString(element, @"DisplaySubclass");
    flight.rate                    = [ObjectElementToString(element, @"Rate") floatValue];
    flight.price                   = [ObjectElementToString(element, @"Price") integerValue];
    flight.standardPrice           = [ObjectElementToString(element, @"StandardPrice") integerValue];
    flight.childStandardPrice      = [ObjectElementToString(element, @"ChildStandardPrice") integerValue];
    flight.babyStandardPrice       = [ObjectElementToString(element, @"BabyStandardPrice") integerValue];
    flight.mealType                = ObjectElementToString(element, @"MealType");
    flight.adultTax                = [ObjectElementToString(element, @"AdultTax") integerValue];
    flight.babyTax                 = [ObjectElementToString(element, @"BabyTax") integerValue];
    flight.childTax                = [ObjectElementToString(element, @"ChildTax") integerValue];
    flight.adultOilFee             = [ObjectElementToString(element, @"AdultOilFee") integerValue];
    flight.babyOilFee              = [ObjectElementToString(element, @"BabyOilFee") integerValue];
    flight.childOilFee             = [ObjectElementToString(element, @"ChildOilFee") integerValue];
    flight.departPortCode          = ObjectElementToString(element, @"DPortCode");
    flight.arrivePortCode          = ObjectElementToString(element, @"APortCode");
    flight.departPortBuildingID    = [ObjectElementToString(element, @"DPortBuildingID") integerValue];
    flight.arrivePortBuildingID    = [ObjectElementToString(element, @"APortBuildingID") integerValue];
    flight.stopTimes               = [ObjectElementToString(element, @"StopTimes") integerValue];
    flight.nonRer                  = ObjectElementToString(element, @"Nonrer");
    flight.nonEnd                  = ObjectElementToString(element, @"Nonend");
    flight.nonRef                  = ObjectElementToString(element, @"Nonref");
    flight.rerNote                 = ObjectElementToString(element, @"Rernote");
    flight.endNote                 = ObjectElementToString(element, @"Endnote");
    flight.refNote                 = ObjectElementToString(element, @"Refnote");
    flight.remarks                 = ObjectElementToString(element, @"Remarks");
    flight.ticketType              = ObjectElementToString(element, @"TicketType");
    flight.beforeFlyDate           = [ObjectElementToString(element, @"BeforeFlyDate") integerValue];
    flight.quantity                = [ObjectElementToString(element, @"Quantity") integerValue];
    flight.priceType               = [NSString priceTypeFromString:ObjectElementToString(element, @"PriceType")];
    flight.productType             = [NSString productTypeFromString:ObjectElementToString(element, @"ProductType")];
    flight.productSource           = [ObjectElementToString(element, @"ProductSource") integerValue];
    flight.inventoryType           = [NSString inventoryTypeFromString:ObjectElementToString(element, @"InventoryType")];
    flight.routeIndex              = [ObjectElementToString(element, @"RouteIndex") integerValue];
    flight.needApplyString         = [ObjectElementToString(element, @"NeedApplyString") boolValue];
    flight.recommend               = [ObjectElementToString(element, @"Recommend") integerValue];
    flight.refundFeeFormulaID      = [ObjectElementToString(element, @"RefundFeeFormulaID") integerValue];
    flight.canUpGrade              = [ObjectElementToString(element, @"CanUpGrade") boolValue];
    flight.canSeparateSale         = ObjectElementToString(element, @"CanSeparateSale");
    flight.canNoDefer              = [ObjectElementToString(element, @"CanNoDefer") boolValue];
    flight.isFlyMan                = [ObjectElementToString(element, @"IsFlyMan") boolValue];
    flight.onlyOwnCity             = [ObjectElementToString(element, @"OnlyOwnCity") boolValue];
    flight.isLowestPrice           = [ObjectElementToString(element, @"IsLowestPrice") boolValue];
    flight.isLowestCZSpecialPrice  = [ObjectElementToString(element, @"IsLowestCZSpecialPrice") boolValue];
    flight.punctualityRate         = [ObjectElementToString(element, @"PunctualityRate") floatValue];
    flight.policyID                = ObjectElementToString(element, @"PolicyID");
    flight.allowCPType             = ObjectElementToString(element, @"AllowCPType");
    flight.outOfPostTime           = [ObjectElementToString(element, @"OutOfPostTime") boolValue];
    flight.outOfSendGetTime        = [ObjectElementToString(element, @"OutOfSendGetTime") boolValue];
    flight.outOfAirlineCounterTime = [ObjectElementToString(element, @"OutOfAirlineCounterTime") boolValue];
    flight.canPost                 = [ObjectElementToString(element, @"CanPost") boolValue];
    flight.canAirlineCounter       = [ObjectElementToString(element, @"CanAirlineCounter") boolValue];
    flight.canSendGet              = [ObjectElementToString(element, @"CanSendGet") boolValue];
    flight.isRebate                = [ObjectElementToString(element, @"IsRebate") boolValue];
    flight.rebateAmount            = [ObjectElementToString(element, @"RebateAmount") floatValue];
    flight.rebateCPCity            = ObjectElementToString(element, @"RebateCPCity");
    
    return flight;
}

@end
