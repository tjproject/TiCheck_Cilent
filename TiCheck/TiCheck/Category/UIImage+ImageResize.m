//
//  UIImage+ImageResize.m
//  TiCheck
//
//  Created by Boyi on 5/18/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "UIImage+ImageResize.h"

@implementation UIImage (ImageResize)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
