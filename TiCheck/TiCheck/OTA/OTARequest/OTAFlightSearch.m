//
//  OTAFlightSearch.m
//  Test
//
//  Created by Boyi on 3/3/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "OTAFlightSearch.h"
#import "ConfigurationHelper.h"
#import "NSString+DateFormat.h"
#import "NSString+EnumTransform.h"

@implementation OTAFlightSearch

- (id)init
{
    if (self = [super init]) {
        _departPort = @"";
        _arrivePort = @"";
        _sendTicketCity = @"";
    }
    
    return self;
}

- (NSString *)generateOTAFlightSearchXMLRequest
{
    NSString *header = [[ConfigurationHelper sharedConfigurationHelper] getHeaderStringWithRequestType:FlightSearchRequest];
    NSString *requestXML = [NSString stringWithFormat:
                            @"&lt;Request&gt;\n"
                            "%@"
                            "&lt;/Request&gt;", [header stringByAppendingString:[self generateFlightSearchRequestXML]]];
    
    return requestXML;
}

#pragma mark - XML生成函数

- (NSString *)generateFlightSearchRequestXML
{
    NSString *searchType          = [NSString stringWithFormat:@"&lt;SearchType&gt;%@&lt;/SearchType&gt;", [NSString flightSearchTypeToString:_searchType]];
    NSString *sendTicketCity      = [NSString stringWithFormat:@"&lt;SendTicketCity&gt;%@&lt;/SendTicketCity&gt;", self.sendTicketCity];
    NSString *isSimpleResponse    = [NSString stringWithFormat:@"&lt;IsSimpleResponse&gt;%@&lt;/IsSimpleResponse&gt;", (self.isSimpleResponse ? @"true" : @"false")];
    NSString *isLowestPrice       = [NSString stringWithFormat:@"&lt;IsLowestPrice&gt;%@&lt;/IsLowestPrice&gt;", (self.isLowestPrice ? @"true" : @"false")];
//    NSString *priceType           = [NSString stringWithFormat:
//                                     @"&lt;PriceTypeOptions&gt;\n"
//                                     "&lt;string&gt;%@&lt;/string&gt;\n"
//                                     "&lt;/PriceTypeOptions", [NSString priceTypeToString:_priceTypeOptions]];
    NSString *productType         = [NSString stringWithFormat:@"&lt;ProductTypeOptions&gt;%@&lt;/ProductTypeOptions&gt;", [NSString productTypeToString:_productTypeOptions]];
    NSString *classGrade          = [NSString stringWithFormat:@"&lt;Classgrade&gt;%@&lt;/Classgrade&gt;", [NSString classGradeToString:_classGrade]];
    NSString *orderCriterion      = [NSString stringWithFormat:@"&lt;OrderBy&gt;%@&lt;/OrderBy&gt;", [NSString orderCriterionToString:_orderBy]];
    NSString *orderDirection      = [NSString stringWithFormat:@"&lt;Direction&gt;%@&lt;/Direction&gt;", [NSString orderDirectionToString:_orderDirection]];

    NSString *flightSearchRequest = [NSString stringWithFormat:
                                     @"&lt;FlightSearchRequest&gt;\n"
                                     "%@\n"
                                     "%@\n"
                                     "%@\n"
                                     "%@\n"
                                     "%@\n"
                                     "%@\n"
                                     "%@\n"
                                     "%@\n"
                                     "%@\n"
                                     "&lt;/FlightSearchRequest&gt;\n", searchType, [self generateRoutesXML], sendTicketCity, isSimpleResponse, isLowestPrice, productType, classGrade, orderCriterion, orderDirection];

    return flightSearchRequest;
}

- (NSString *)generateRoutesXML
{
    NSString *departCity         = [NSString stringWithFormat:@"&lt;DepartCity&gt;%@&lt;/DepartCity&gt;", self.departCity];
    NSString *arriveCity         = [NSString stringWithFormat:@"&lt;ArriveCity&gt;%@&lt;/ArriveCity&gt;", self.arriveCity];
    NSString *departDate         = [NSString stringWithFormat:@"&lt;DepartDate&gt;%@&lt;/DepartDate&gt;", [NSString stringFormatWithDate:self.departDate]];
    NSString *airline            = [NSString stringWithFormat:@"&lt;AirlineDibitCode&gt;%@&lt;/AirlineDibitCode&gt;", self.airline];
    NSString *departPort         = [NSString stringWithFormat:@"&lt;DepartPort&gt;%@&lt;/DepartPort&gt;", self.departPort];
    NSString *arrivePort         = [NSString stringWithFormat:@"&lt;ArrivePort&gt;%@&lt;/ArrivePort&gt;", self.arrivePort];
//    NSString *earliestDepartTime = [NSString stringWithFormat:@"&lt;EarliestDepartTime&gt;%@&lt;/EarliestDepartTime&gt;", [NSString stringFormatWithTime:self.earliestDepartTime]];
//    NSString *latestDepartTime   = [NSString stringWithFormat:@"&lt;LatestDepartTime&gt;%@&lt;/LatestDepartTime&gt;", [NSString stringFormatWithTime:self.latestDepartTime]];

    NSString *routesXML          = [NSString stringWithFormat:
                                    @"&lt;Routes&gt;\n"
                                    "&lt;FlightRoute&gt;\n"
                                    "%@\n"
                                    "%@\n"
                                    "%@\n"
                                    "%@\n"
                                    "%@\n"
                                    "%@\n"
                                    "&lt;/FlightRoute&gt;\n"
                                    "&lt;/Routes&gt;", departCity, arriveCity, departDate, airline, departPort, arrivePort];
    
    return routesXML;
}

@end
