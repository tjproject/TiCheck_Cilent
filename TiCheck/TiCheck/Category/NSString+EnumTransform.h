//
//  NSString+EnumTransform.h
//  Test
//
//  Created by Boyi on 3/12/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumCollection.h"

@interface NSString (EnumTransform)

#pragma mark - Enumeration to NSString

+ (NSString *)classGradeToString:(ClassGrade)classGrade;
+ (NSString *)priceTypeToString:(PriceType)priceType;
+ (NSString *)productTypeToString:(ProductType)productType;

+ (NSString *)flightSearchTypeToString:(FlightSearchType)searchType;
+ (NSString *)orderCriterionToString:(OrderCriterion)orderBy;
+ (NSString *)orderDirectionToString:(OrderDirection)orderDirection;

+ (NSString *)ageTypeToString:(AgeType)ageType;
+ (NSString *)confirmOptionToString:(ConfirmOption)confirmOption;
+ (NSString *)deliveryTypeToString:(DeliveryType)deliveryType;
//+ (NSString *)productSourceToString:(ProductSource)productSource;
+ (NSString *)inventoryTypeToString:(InventoryType)inventoryType;

//+ (NSString *)orderStatusToString:(OrderStatus)orderStatus;

+ (NSString *)genderToString:(Gender)gender;
+ (NSString *)flightOrderClassToString:(FlightOrderClass)flightOrderClass;

#pragma mark - NSString to Enumeration

+ (ClassGrade)classGradeFromString:(NSString *)classGrade;
+ (PriceType)priceTypeFromString:(NSString *)priceType;
+ (ProductType)productTypeFromString:(NSString *)productType;

+ (FlightSearchType)flightSearchTypeFromString:(NSString *)searchType;
+ (OrderCriterion)orderCriterionFromString:(NSString *)orderBy;
+ (OrderDirection)orderDirectionFromString:(NSString *)orderDirection;

+ (AgeType)ageTypeFromString:(NSString *)ageType;
+ (ConfirmOption)confirmOptionFromString:(NSString *)confirmOption;
+ (DeliveryType)deliveryTypeFromString:(NSString *)deliveryType;
+ (InventoryType)inventoryTypeFromString:(NSString *)inventoryType;

+ (OrderStatus)orderStatusFromString:(NSString *)orderStatus;

+ (Gender)genderFromString:(NSString *)gender;
+ (FlightOrderClass)flightOrderClassFromString:(NSString *)flightOrderClass;

@end
