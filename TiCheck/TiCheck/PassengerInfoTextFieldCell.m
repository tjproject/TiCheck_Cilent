//
//  PassengerInfoTextFieldCell.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-27.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PassengerInfoTextFieldCell.h"

@implementation PassengerInfoTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.inputInfoTextField.returnKeyType =UIReturnKeyDone;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
