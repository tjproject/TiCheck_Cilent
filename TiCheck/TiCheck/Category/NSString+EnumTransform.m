//
//  NSString+EnumTransform.m
//  Test
//
//  Created by Boyi on 3/12/14.
//  Copyright (c) 2014 boyi. All rights reserved.
//

#import "NSString+EnumTransform.h"

@implementation NSString (EnumTransform)

#pragma mark - Enumeration To String

+ (NSString *)classGradeToString:(ClassGrade)classGrade
{
    NSString *result = nil;
    
    switch (classGrade) {
        case Y:
            result = @"Y";
            break;
        case C:
            result = @"C";
            break;
        case F:
            result = @"F";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected ClassGrade."];
    }
    
    return result;
}

+ (NSString *)priceTypeToString:(PriceType)priceType
{
    NSString *result = nil;
    
    switch (priceType) {
        case NormalPrice:
            result = @"NormalPrice";
            break;
        case SingleTripPrice:
            result = @"SingleTripPrice";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected PriceType."];
    }
    
    return result;
}

+ (NSString *)productTypeToString:(ProductType)productType
{
    NSString *result = nil;
    
    switch (productType) {
        case Normal:
            result = @"Normal";
            break;
        case YoungMan:
            result = @"YoungMan";
            break;
        case OldMan:
            result = @"OldMan";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected ProductType"];
    }
    
    return result;
}

+ (NSString *)flightSearchTypeToString:(FlightSearchType)searchType
{
    NSString *result = nil;
    
    switch(searchType) {
        case S:
            result = @"S";
            break;
        case R:
            result = @"R";
            break;
        case M:
            result = @"M";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected SearchType."];
    }
    
    return result;
}

+ (NSString *)orderCriterionToString:(OrderCriterion)orderBy
{
    NSString *result = nil;
    
    switch (orderBy) {
        case DepartTime:
            result = @"DepartTime";
            break;
        case TakeOffTime:
            result = @"TakeOffTime";
            break;
        case Price:
            result = @"Price";
            break;
        case Rate:
            result = @"Rate";
            break;
        case LowPrice:
            result = @"LowPrice";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected OrderCriterion."];
    }
    
    return result;
}

+ (NSString *)orderDirectionToString:(OrderDirection)orderDirection
{
    NSString *result = nil;
    
    switch (orderDirection) {
        case ASC:
            result = @"ASC";
            break;
        case Desc:
            result = @"Desc";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected OrderDirection"];
    }
    
    return result;
}

+ (NSString *)ageTypeToString:(AgeType)ageType
{
    NSString *result = nil;
    
    switch (ageType) {
        case ADU:
            result = @"ADU";
            break;
        case CHI:
            result = @"CHI";
            break;
        case BAB:
            result = @"BAB";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected AgeType."];
    }
    
    return result;
}

+ (NSString *)confirmOptionToString:(ConfirmOption)confirmOption
{
    NSString *result = nil;
    
    switch (confirmOption) {
        case TEL:
            result = @"TEL";
            break;
        case EML:
            result = @"EML";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected ConfirmOption."];
    }
    
    return result;
}

+ (NSString *)deliveryTypeToString:(DeliveryType)deliveryType
{
    NSString *result = nil;
    
    switch (deliveryType) {
        case PJS:
            result = @"PJS";
            break;
        case PJN:
            result = @"PJN";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected DeliveryType."];
    }
    
    return result;
}

+ (NSString *)inventoryTypeToString:(InventoryType)inventoryType
{
    NSString *result = nil;
    
    switch (inventoryType) {
        case FIX:
            result = @"FIX";
            break;
        case FAV:
            result  =@"FAV";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected InventoryType."];
    }
    
    return result;
}

#pragma mark - NSString to Enumeration

+ (FlightSearchType)flightSearchTypeFromString:(NSString *)searchType
{
    FlightSearchType result = S;
    
         if ([searchType isEqualToString:@"S"]) result = S;
    else if ([searchType isEqualToString:@"M"]) result = M;
    else if ([searchType isEqualToString:@"R"]) result = R;
    else if ([searchType isEqualToString:@"D"]) result = R;
    
    return result;
}

+ (OrderStatus)orderStatusFromString:(NSString *)orderStatus
{
    OrderStatus result = AllOrders;
    
         if ([orderStatus isEqualToString:@"W"]) result = Unprocessed;
    else if ([orderStatus isEqualToString:@"P"]) result = Processing;
    else if ([orderStatus isEqualToString:@"S"]) result = Deal;
    else if ([orderStatus isEqualToString:@"C"]) result = Cancelled;
    else if ([orderStatus isEqualToString:@"R"]) result = AllRefund;
    else if ([orderStatus isEqualToString:@"T"]) result = PartRefund;
    else if ([orderStatus isEqualToString:@"U"]) result = Uncommitted;
    
    return result;
}

+ (Gender)genderFromString:(NSString *)gender
{
    Gender result = Male;
    
    if ([gender isEqualToString:@"M"]) result = Male;
    else if ([gender isEqualToString:@"F"]) result = Female;
    
    return result;
}

@end
