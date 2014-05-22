//
//  CraftType.m
//  TiCheck
//
//  Created by Boyi on 4/16/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "CraftType.h"

@implementation CraftType

- (id)init
{
    if (self = [super init]) {
        _craftType = _ctName = _widthLevel = _note = _ctEName = _craftKind = @"未知机型";
        _minSeats = _maxSeats = 0;
    }
    
    return self;
}

- (NSString *)craftKindShowingOnResult
{
    NSString *result = @"未知";
    
    if (_craftType != nil && ![_craftType isEqualToString:@""]) {
//        result = _craftType;
        NSString *kind = @"";
        
        if ([_craftKind isEqualToString:@"S"]) kind = @"小";
        else if ([_craftKind isEqualToString:@"M"]) kind = @"中";
        else if ([_craftKind isEqualToString:@"L"]) kind = @"大";
        else kind = @"";
        
        result = [_craftType stringByAppendingString:kind];
    }
    
    return result;
}

- (NSString *)craftKindShowingOnResultInTicketInfo
{
    NSString *result = @"未知机型";
    
    if (_craftType != nil && ![_craftType isEqualToString:@"未知机型"]) {
//        result = _craftType;
        NSString *kind = @"未知机型";
        
        if ([_craftKind isEqualToString:@"S"]) kind = @"小型机";
        else if ([_craftKind isEqualToString:@"M"]) kind = @"中型机";
        else if ([_craftKind isEqualToString:@"L"]) kind = @"大型机";
        else kind = @"未知机型";
        
        result = [_craftType stringByAppendingString:kind];
    }
    
    return result;
}

@end
