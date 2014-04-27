//
//  DateSelectViewController.h
//  TiCheck
//
//  Created by Boyi on 4/21/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, RouteType) {
    Take_Off,
    Return
};

@protocol DateSelectViewControllerDelegate <NSObject>

- (void)setTakeOffTimeLabel:(NSDate *)takeOffDate;
- (void)setReturnTimeLabel:(NSDate *)returnDate;

@end

@interface DateSelectViewController : ViewController

@property (nonatomic, weak) id<DateSelectViewControllerDelegate> delegate;
@property (nonatomic) RouteType routeType;

@property (nonatomic) BOOL isTodayButtonHidden;

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *selectedDate;

@end
