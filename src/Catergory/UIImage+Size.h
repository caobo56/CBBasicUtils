//
//  UIImage+Category.h
//  live
//
//  Created by kenneth on 15-7-9.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Size)

/**
 imageWithImage

 @param image image
 @param newSize newSize
 @return return value
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/**
 将图片压缩到0.5M。不改变大小，压缩质量

 @param image image description
 @return return value scaledForUpload
 */
+ (UIImage *)scaledForUpload:(UIImage *)image;

/**
 将图片压缩
 
 @param image 要压缩的图片
 @param maxLength maxLength 要压缩到的byte大小
 @return return image 压缩的图片
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

/**
 提供微信大小的图片

 @return return value 
 */
-(UIImage *)wewixinSizeThumb;

@end
