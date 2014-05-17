//
//  FlightOrder.m
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Order.h"

@implementation Order

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
