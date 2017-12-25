//
//  UIView+screenshots.m
//  jingduoduo
//
//  Created by diaojz on 16/3/31.
//  Copyright © 2016年 totem. All rights reserved.
//

#import "UIView+screenshots.h"

@implementation UIView (screenshots)
/**
 *  获取全屏截图
 */
- (UIImage *)p_getFullScreenshots
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage,self.frame)];
    return image;
}

@end
