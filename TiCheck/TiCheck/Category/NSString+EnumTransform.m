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

+ (NSString *)genderToString:(Gender)gender
{
    NSString *result = nil;
    
    switch (gender) {
        case Male:
            result = @"M";
            break;
        case Female:
            result = @"F";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected Gender."];
    }
    
    return result;
}

+ (NSString *)classGradeToChinese:(ClassGrade)classGrade
{
    NSString *result = nil;
    
    switch (classGrade) {
        case Y:
            result = @"经济舱";
            break;
        case C:
            result = @"公务舱";
            break;
        case F:
            result = @"头等舱";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected ClassGrade"];
    }
    
    return result;
}

#pragma mark - NSString to Enumeration

+ (ClassGrade)classGradeFromString:(NSString *)classGrade
{
    ClassGrade result = Y;
    
         if ([classGrade caseInsensitiveCompare:@"Y"] == NSOrderedSame) result = Y;
    else if ([classGrade caseInsensitiveCompare:@"C"] == NSOrderedSame) result = C;
    else if ([classGrade caseInsensitiveCompare:@"F"] == NSOrderedSame) result = F;
    
    return result;
}

+ (PriceType)priceTypeFromString:(NSString *)priceType
{
    PriceType result = NormalPrice;
    
         if ([priceType caseInsensitiveCompare:@"NormalPrice"] == NSOrderedSame)     result = NormalPrice;
    else if ([priceType caseInsensitiveCompare:@"SingleTripPrice"] == NSOrderedSame) result = SingleTripPrice;
    else if ([priceType caseInsensitiveCompare:@"CZSpecialPrice"] == NSOrderedSame)  result = CZSpecialPrice;
    
    return result;
}

+ (ProductType)productTypeFromString:(NSString *)productType
{
    ProductType result = Normal;
    
         if ([productType caseInsensitiveCompare:@"Normal"] == NSOrderedSame)   result = Normal;
    else if ([productType caseInsensitiveCompare:@"YoungMan"] == NSOrderedSame) result = YoungMan;
    else if ([productType caseInsensitiveCompare:@"OldMan"] == NSOrderedSame)   result = OldMan;
    
    return result;
}

+ (FlightSearchType)flightSearchTypeFromString:(NSString *)searchType
{
    FlightSearchType result = S;
    
         if ([searchType caseInsensitiveCompare:@"S"] == NSOrderedSame) result = S;
    else if ([searchType caseInsensitiveCompare:@"M"] == NSOrderedSame) result = M;
    else if ([searchType caseInsensitiveCompare:@"R"] == NSOrderedSame) result = R;
    else if ([searchType caseInsensitiveCompare:@"D"] == NSOrderedSame) result = R;
    
    return result;
}

+ (OrderCriterion)orderCriterionFromString:(NSString *)orderBy
{
    OrderCriterion result = DepartTime;
    
         if ([orderBy caseInsensitiveCompare:@"DepartTime"] == NSOrderedSame)  result = DepartTime;
    else if ([orderBy caseInsensitiveCompare:@"TakeOffTime"] == NSOrderedSame) result = TakeOffTime;
    else if ([orderBy caseInsensitiveCompare:@"Price"] == NSOrderedSame)       result = Price;
    else if ([orderBy caseInsensitiveCompare:@"Rate"] == NSOrderedSame)        result = Rate;
    else if ([orderBy caseInsensitiveCompare:@"LowPrice"] == NSOrderedSame)    result = LowPrice;
    
    return result;
}

+ (OrderDirection)orderDirectionFromString:(NSString *)orderDirection
{
    OrderDirection result = ASC;
    
         if ([orderDirection caseInsensitiveCompare:@"ASC"] == NSOrderedSame)  result = ASC;
    else if ([orderDirection caseInsensitiveCompare:@"Desc"] == NSOrderedSame) result = Desc;
    
    return result;
}

+ (AgeType)ageTypeFromString:(NSString *)ageType
{
    AgeType result = ADU;
    
         if ([ageType caseInsensitiveCompare:@"ADU"] == NSOrderedSame) result = ADU;
    else if ([ageType caseInsensitiveCompare:@"BAB"] == NSOrderedSame) result = BAB;
    else if ([ageType caseInsensitiveCompare:@"CHI"] == NSOrderedSame) result = CHI;
    
    return result;
}

+ (InventoryType)inventoryTypeFromString:(NSString *)inventoryType
{
    InventoryType result = FIX;
    
         if ([inventoryType caseInsensitiveCompare:@"FIX"] == NSOrderedSame) result = FIX;
    else if ([inventoryType caseInsensitiveCompare:@"FAV"] == NSOrderedSame) result = FAV;
    
    return result;
}

+ (OrderStatus)orderStatusFromString:(NSString *)orderStatus
{
    OrderStatus result = AllOrders;
    
         if ([orderStatus caseInsensitiveCompare:@"W"] == NSOrderedSame) result = Unprocessed;
    else if ([orderStatus caseInsensitiveCompare:@"P"] == NSOrderedSame) result = Processing;
    else if ([orderStatus caseInsensitiveCompare:@"S"] == NSOrderedSame) result = Deal;
    else if ([orderStatus caseInsensitiveCompare:@"C"] == NSOrderedSame) result = Cancelled;
    else if ([orderStatus caseInsensitiveCompare:@"R"] == NSOrderedSame) result = AllRefund;
    else if ([orderStatus caseInsensitiveCompare:@"T"] == NSOrderedSame) result = PartRefund;
    else if ([orderStatus caseInsensitiveCompare:@"U"] == NSOrderedSame) result = Uncommitted;
    
    return result;
}

+ (Gender)genderFromString:(NSString *)gender
{
    Gender result = Male;
    
         if ([gender caseInsensitiveCompare:@"M"] == NSOrderedSame) result = Male;
    else if ([gender caseInsensitiveCompare:@"F"] == NSOrderedSame) result = Female;
    
    return result;
}

+ (FlightOrderClass)flightOrderClassFromString:(NSString *)flightOrderClass
{
    FlightOrderClass result = Domestic;
    
         if ([flightOrderClass caseInsensitiveCompare:@"D"] == NSOrderedSame) result = Domestic;
    else if ([flightOrderClass caseInsensitiveCompare:@"I"] == NSOrderedSame) result = International;
    
    return result;
}

@end
