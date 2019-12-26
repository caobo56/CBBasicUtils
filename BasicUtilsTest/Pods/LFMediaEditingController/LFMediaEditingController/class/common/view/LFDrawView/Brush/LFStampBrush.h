//
//  LFStampBrush.h
//  LFMediaEditingController
//
//  Created by TsanFeng Lam on 2019/9/2.
//  Copyright © 2019 LamTsanFeng. All rights reserved.
//

#import "LFBrush.h"

NS_ASSUME_NONNULL_BEGIN

OBJC_EXTERN NSString *const LFStampBrushPatterns;
OBJC_EXTERN NSString *const LFStampBrushSpacing;
OBJC_EXTERN NSString *const LFStampBrushScale;

@class LFStampBrush;
OBJC_EXTERN LFStampBrush *LFStampBrushAnimal(void);
OBJC_EXTERN LFStampBrush *LFStampBrushFruit(void);
OBJC_EXTERN LFStampBrush *LFStampBrushHeart(void);

@interface LFStampBrush : LFBrush

/** 图案间隔 默认1 */
@property (nonatomic, assign) CGFloat spacing;
/** 线粗的缩放系数（图案大小） 默认4 */
@property (nonatomic, assign) CGFloat scale;
/** 印章图案名称 */
@property (nonatomic, strong) NSArray <NSString *> *patterns;

@end

NS_ASSUME_NONNULL_END
