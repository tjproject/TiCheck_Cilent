//
//  TickectInfoPicker.h
//  TiCheck
//
//  Created by 大畅 on 14-4-24.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TickectInfoPickerDelegate <NSObject>

@required

- (NSArray*)generatePickerDataWithView:(UIView*)view;

@end

@interface TickectInfoPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign, readonly) UIPickerView *picker;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSString *pickerTitle;

- (void) addTargetForDoneButton: (id) target action: (SEL) action;
- (void) addTargetForCancelButton: (id) target action: (SEL) action;

- (void)initPickerData;
- (void)initPickerToolBarWithTitle:(NSString*)title;

@property (nonatomic, assign) id<TickectInfoPickerDelegate> delegate;

@end
