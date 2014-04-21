//
//  CitySelectViewController.h
//  TiCheck
//
//  Created by Boyi on 4/20/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SelectCityType) {
    From_City,
    To_City
};

@protocol CitySelectViewControllerDelegate <NSObject>

- (void)setFromCityLabel:(NSString *)fromCityString;
- (void)setToCityLabel:(NSString *)toCityString;

@end

@interface CitySelectViewController : UIViewController

@property (nonatomic, weak) id<CitySelectViewControllerDelegate> delegate;

@property (nonatomic) SelectCityType selectCityType;

@end
