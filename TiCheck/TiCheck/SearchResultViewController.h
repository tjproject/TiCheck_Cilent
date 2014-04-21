//
//  SearchResultViewController.h
//  TiCheck
//
//  Created by 邱峰 on 14-4-3.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "ViewController.h"

#define FROM_CITY_KEY @"FromCity"
#define TO_CITY_KEY @"ToCity"
#define TAKE_OFF_TIME_KEY @"TakeOffTime"
#define RETURN_TIME_KEY @"ReturnTime"

@interface SearchResultViewController : ViewController

@property (nonatomic, strong) NSDictionary *searchOptionDic;

@end
