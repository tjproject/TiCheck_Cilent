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
        _craftType = _ctName = _widthLevel = _note = _ctEName = _craftKind = @"";
        _minSeats = _maxSeats = 0;
    }
    
    return self;
}

- (NSString *)craftKindShowingOnResult
{
    NSString *result = @"未知";
    
    if (_craftType != nil && ![_craftType isEqualToString:@""]) {
        result = _craftType;
        NSString *kind = @"";
        
        if ([_craftKind isEqualToString:@"S"]) kind = @"小";
        else if ([_craftKind isEqualToString:@"M"]) kind = @"中";
        else if ([_craftKind isEqualToString:@"L"]) kind = @"大";
        else kind = @"";
        
        result = [_craftType stringByAppendingString:kind];
    }
    
    return result;
}

@end
