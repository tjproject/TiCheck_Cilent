//
//  UIImage+ImageResize.h
//  TiCheck
//
//  Created by Boyi on 5/18/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageResize)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
