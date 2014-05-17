//
//  ScreeningViewController.h
//  TiCheck
//
//  Created by 大畅 on 14-5-11.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScreeningViewControllerDelegate <NSObject>

- (void)prepareScreeningDataWithFromCity:(NSString*)fCity ToCity:(NSString*)tCity TakeOffDate:(NSString*)tDate Airline:(NSString*)airlineName SeatType:(NSString*)seatType FromAirport:(NSString*)fAirport ToAirport:(NSString*)tAirport TakeOffTime:(NSString*)tTime;

@end

@interface ScreeningViewController : UIViewController

@property (strong, nonatomic) NSString *fromCity;
@property (strong, nonatomic) NSString *toCity;
@property (strong, nonatomic) NSString *takeOffDate;

@property (nonatomic, assign) id<ScreeningViewControllerDelegate> delegate;

- (void)setAirplineCellTextWithString:(NSString*)airlineText SeatCell:(NSString*)seatText FromCell:(NSString*)fromText ToCell:(NSString*)toText takeOffCell:(NSString*)takeOffText;

@end
