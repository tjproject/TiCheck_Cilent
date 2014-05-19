//
//  FlightOrder.m
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Order.h"

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

- (NSDictionary *)dictionaryWithOrderOption
{
    NSMutableDictionary *orderDictionary = [NSMutableDictionary dictionary];
    
    [orderDictionary setValue:self.OrderID forKeyPath:ORDER_ID];
    [orderDictionary setValue:self.orderTime forKeyPath:ORDER_TIME];
    [orderDictionary setValue:[NSString stringWithFormat:@"%ld",(long)self.amount] forKeyPath:AMOUNT];
    [orderDictionary setValue:self.orderDesc forKeyPath:ORDER_DESC];
    [orderDictionary setValue:[NSString stringWithFormat:@"%ld",(long)self.persons] forKeyPath:PERSONS];
    
    return orderDictionary;
}



@end
