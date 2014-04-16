//
//  DomesticCity.m
//  TiCheck
//
//  Created by Boyi on 4/13/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "DomesticCity.h"

@implementation DomesticCity

- (id)init
{
    if (self = [super init]) {
        _cityCode = _cityName = _cityEName = @"";
        _cityID = _countryID = _provinceID = 0;
        _airports = [NSArray array];
    }
    
    return self;
}

@end
