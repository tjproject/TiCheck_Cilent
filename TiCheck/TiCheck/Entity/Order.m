//
//  FlightOrder.m
//  Test
//
//  Created by Boyi on 3/16/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "Order.h"
#import "PrintObject.h"
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
    //
    return order;
}

+ (NSMutableArray *)orderWithDiscitionary:(NSDictionary*) dictionary
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dataDictionary in dictionary[@"Data"]) {
        //把 string 提取出来， 再重新执行一次 json 转化， 即得到 dictionary
        NSData *dData = [dataDictionary[@"OrderDetail"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *entityDictionary = [NSJSONSerialization JSONObjectWithData:dData options:NSJSONReadingMutableContainers error:nil];
        //
        Order *tempOrder = [self createOrderWithDictionary:entityDictionary];
        [resultArray addObject:tempOrder];
    }
    
    return resultArray;
}
//    //test get order from server
//    NSDictionary *returnDic = [[ServerCommunicator sharedCommunicator] getOrderInfo:nil];
//    NSInteger returnCode = [returnDic[SERVER_RETURN_CODE_KEY] integerValue];
//    
//    
//    //test: 把 string 提取出来， 再重新执行一次 json 转化， 即得到 dictionary
//    NSDictionary *d = [returnDic[@"Data"] objectAtIndex:5];
//    NSData *testData2 = [d[@"OrderDetail"] dataUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    NSData *testData = [@"testdata" dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *testD = [NSJSONSerialization JSONObjectWithData:testData2 options:NSJSONReadingMutableContainers error:nil];






- (NSDictionary *)dictionaryWithOrderOption
{
    NSDictionary *result = [PrintObject getObjectData:self];
    //[PrintObject print:self];
    return result;
}

@end
