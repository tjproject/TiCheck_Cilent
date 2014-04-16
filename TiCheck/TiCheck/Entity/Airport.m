//
//  Airport.m
//  TiCheck
//
//  Created by Boyi on 4/16/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "Airport.h"

@implementation Airport

- (id)init {
    if (self = [super init]) {
        _airportCode = _airportName = _airportEName = _airportShortName = _cityName = @"";
        _cityID = 0;
    }
    
    return self;
}

@end
