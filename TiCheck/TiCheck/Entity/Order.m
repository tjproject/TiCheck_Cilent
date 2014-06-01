//
//  FlightOrder.m
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Order.h"
#import "PrintObject.h"
#import "NSString+DateFormat.h"
#import "Flight.h"
#import "Passenger.h"
//@class Order;

@implementation Order

- (id)init
{
    if (self = [super init]) {
        
    }
    
    return  self;
}

+ (Order *)orderWithOrderId:(NSString *)orderId
                flightsList:(NSArray *)flighs
             passengersList:(NSArray *)passengers
                orderStatus:(OrderStatus)status
                totalAmount:(NSInteger)tAmount
                  insurance:(NSInteger)fee
{
    Order *order = [[Order alloc] init];
    order.OrderID = orderId;
    order.flightsList = flighs;
    order.passengersList = passengers;
    order.orderStatus = status;
    order.amount = tAmount;
    order.insuranceFee = fee;
    return order;
}

+ (Order *)createOrderWithDictionary:(NSDictionary *) dictionary
{
    //
    Order *order = [[Order alloc] init];
    //手动生成order
    //单独生成Array类型
    NSMutableArray *flightsList = [[NSMutableArray alloc] init];
    NSArray *flightsData = dictionary[@"flightsList"];
    for (NSDictionary * flightDictionary in flightsData) {
        Flight *tempFlight = [Flight createFilghtWithDictionary:flightDictionary];
        [flightsList addObject:tempFlight];
    }
    order.flightsList = flightsList;
    
    NSMutableArray *passengersList = [[NSMutableArray alloc] init];
    NSArray *passengersData = dictionary[@"passengersList"];
    for (NSDictionary * passengerDictionary in passengersData) {
        Passenger *tempPassenger = [Passenger createPassengerWithDictionary:passengerDictionary isTemporary:YES];
        [passengersList addObject:tempPassenger];
    }
    order.passengersList = passengersList;
    
    //日期类型
    order.orderTime = [NSString timeFormatWithString:dictionary[@"orderTime"]];
    order.latestChangedTime = [NSString timeFormatWithString:dictionary[@"latestChangedTime"]];
    //基本类型
    order.OrderID = dictionary[@"OrderID"];
    order.sendTicketCity = dictionary[@"sendTicketCity"];
    order.sendTicketCityID = [dictionary[@"sendTicketCityID"] integerValue];
    order.flightWay = [dictionary[@"flightWay"] integerValue];
    order.orderDesc = dictionary[@"orderDesc"];
    order.orderStatus = [dictionary[@"orderStatus"] integerValue];
    order.amount = [dictionary[@"amount"] integerValue];
    order.insuranceFee = [dictionary[@"insuranceFee"] integerValue];
    order.emoney = [dictionary[@"emoney"] integerValue];
    order.actualAmount = [dictionary[@"actualAmount"] integerValue];
    order.cCardPayFee = [dictionary[@"cCardPayFee"] floatValue];
    order.serverFee = [dictionary[@"serverFee"] floatValue];
    order.processStatus = [dictionary[@"processStatus"] integerValue];
    order.sendTicketFee = [dictionary[@"sendTicketFee"] integerValue];
    order.getTicketWay = dictionary[@"getTicketWay"];
    order.eAccountAmount = [dictionary[@"eAccountAmount"] integerValue];
    order.persons = [dictionary[@"persons"] integerValue];
    order.isEnglish = [dictionary[@"isEnglish"] boolValue];
    order.flightOrderClass = [dictionary[@"flightOrderClass"] integerValue];
    order.stopsInfo = dictionary[@"stopsInfo"];
    order.promopts = dictionary[@"promopts"];
    
    return order;
}

+ (NSMutableArray *)orderWithDiscitionary:(NSDictionary*) dictionary
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    id stringResult = dictionary[@"Data"];
    if([stringResult isKindOfClass:[NSString class]])
    {
        //
        return  nil;
    }
    else
    {
        for (NSDictionary *dataDictionary in dictionary[@"Data"])
        {
            //把 string 提取出来， 再重新执行一次 json 转化， 即得到 dictionary
            NSData *dData = [dataDictionary[@"OrderDetail"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *entityDictionary = [NSJSONSerialization JSONObjectWithData:dData options:NSJSONReadingMutableContainers error:nil];
            //
            Order *tempOrder = [self createOrderWithDictionary:entityDictionary];
            [resultArray addObject:tempOrder];
        }
        return resultArray;
    }
    
}





- (NSDictionary *)dictionaryWithOrderOption
{
    NSDictionary *result = [PrintObject getObjectData:self];
    //[PrintObject print:self];
    return result;
}

@end
