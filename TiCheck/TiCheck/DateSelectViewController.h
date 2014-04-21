//
//  DateSelectViewController.h
//  TiCheck
//
//  Created by Boyi on 4/21/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "ViewController.h"

@protocol DateSelectViewControllerDelegate <NSObject>

- (void)setTakeOffTimeLabel:(NSDate *)takeOffTime;

@end

@interface DateSelectViewController : ViewController

@property (nonatomic, weak) id<DateSelectViewControllerDelegate> delegate;

@property (nonatomic, strong) NSDate *selectedDate;

@end
