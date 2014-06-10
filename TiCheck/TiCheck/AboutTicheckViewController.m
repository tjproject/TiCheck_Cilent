//
//  AboutTicheckViewController.m
//  TiCheck
//
//  Created by 大畅 on 14/6/10.
//  Copyright (c) 2014年 tac. All rights reserved.
//

#import "AboutTicheckViewController.h"

@implementation AboutTicheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"关于Ticheck";
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        UIImageView *mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        mainImage.image = [UIImage imageNamed:@"aboutTicheck"];
        [self.view addSubview:mainImage];
    }
    else
    {
        UIImageView *mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        mainImage.image = [UIImage imageNamed:@"about35"];
        [self.view addSubview:mainImage];
    }

}

@end
