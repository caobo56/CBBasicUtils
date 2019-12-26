//
//  LFImageCoder.h
//  LFMediaEditingController
//
//  Created by TsanFeng Lam on 2019/9/20.
//  Copyright © 2019 LamTsanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 参考YYImageCoder对图片解码 */


/**
 图片解码

 @param image 图片
 @return 返回解码后的图片，如果失败，则返回NULL
 */
CG_EXTERN CGImageRef _Nullable newCGImageDecodedCopy(UIImage *image);

/**
 图片解码

 @param image 图片
 @return 返回解码后的图片，如果失败，则返回nil
 */
UIKIT_EXTERN UIImage * _Nullable newUIImageDecodedCopy(UIImage *image);

NS_ASSUME_NONNULL_END
