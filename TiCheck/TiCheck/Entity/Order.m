//
//  FlightOrder.m
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Order.h"
#import "PrintObject.h"
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

+ (Order *)orderWithDiscitionary:(NSDictionary*) dictionary
{
    Order *order = [[Order alloc] init];
    return order;
}




- (NSDictionary *)dictionaryWithOrderOption
{
    NSDictionary *result = [PrintObject getObjectData:self];
    //[PrintObject print:self];
    return result;
}

@end
