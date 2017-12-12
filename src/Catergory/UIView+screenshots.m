//
//  UIView+screenshots.m
//  jingduoduo
//
//  Created by diaojz on 16/3/31.
//  Copyright © 2016年 totem. All rights reserved.
//

#import "UIView+screenshots.h"
#import "AppDelegate.h"



@implementation UIView (screenshots)
/**
 *  获取全屏截图
 */
- (UIImage *)p_getFullScreenshotsWithView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage,view.frame)];
    return image;
}

@end
