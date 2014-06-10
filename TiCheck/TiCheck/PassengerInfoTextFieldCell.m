//
//  PassengerInfoTextFieldCell.m
//  TiCheck
//
//  Created by 黄泽彪 on 14-4-27.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "PassengerInfoTextFieldCell.h"
#define IS_IPHONE_LOWERINCHE [[UIScreen mainScreen] bounds].size.height == 480

@implementation PassengerInfoTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.inputInfoTextField.returnKeyType = UIReturnKeyDefault;
        
    }
    return self;
}



- (void) setSelfDelegate
{
    self.inputInfoTextField.delegate = self.passengerViewControl;
}



- (void)awakeFromNib
{
    // Initialization code
    self.inputInfoTextField.returnKeyType = UIReturnKeyDefault;
    self.inputInfoTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder
    //NSTimeInterval animationDuration = 0.30f;
    
    if(IS_IPHONE_LOWERINCHE)
    {
        if(self.cellIndex<1||self.cellIndex>3)
        {
            
        CGRect frame = self.mainTableView.frame;
        
        frame.size.height = 260;
        self.mainTableView.frame = frame;
        
        self.mainTableView.scrollEnabled = YES;
            
            
        //self.inputInfoTextField
        //self.mainTableView.userInteractionEnabled = NO;
        }
    }
    
    
    return YES;
    //[UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    if(IS_IPHONE_LOWERINCHE)
    {
        CGRect frame = self.mainTableView.frame;
        
        frame.size.height = 480;
        self.mainTableView.frame = frame;
        
        self.mainTableView.scrollEnabled = NO;
        //self.mainTableView.userInteractionEnabled = YES;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
