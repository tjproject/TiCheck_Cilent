//
//  SearchOption.h
//  TiCheck
//
//  Created by Boyi on 4/21/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchOption : NSObject

@property (nonatomic, strong) NSString *departCityName;
@property (nonatomic, strong) NSString *arriveCityName;
@property (nonatomic, strong) NSDate *takeOffDate;
@property (nonatomic, strong) NSDate *returnDate;

+ (SearchOption *)sharedSearchOption;

@end
