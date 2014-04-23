//
//  GeneralOptionTableViewCell.h
//  TiCheck
//
//  Created by Boyi on 4/22/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralOptionTableViewCell : UITableViewCell

/**
 *  Option栏中左侧icon
 */
@property (weak, nonatomic) IBOutlet UIImageView *generalIcon;

/**
 *  Label显示Option名
 */
@property (weak, nonatomic) IBOutlet UILabel *generalLabel;

/**
 *  使用button显示选择值
 */
@property (weak, nonatomic) IBOutlet UIButton *generalValue;

@end
