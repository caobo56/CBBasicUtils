//
//  LFMEGifView.h
//  LFMediaEditingController
//
//  Created by TsanFeng Lam on 2019/6/24.
//  Copyright © 2019 lincf0912. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFMEGifView : UIView

@property (nonatomic, strong, nullable) UIImage *gifImage;

/**
 Whether this instance is auto play.
 */
@property (assign, nonatomic) BOOL autoPlay;

/**
 Number of times gif played.
 */
@property (assign, nonatomic) NSUInteger loopCount;

/**
 Whether this instance play gif.
 */
- (void)playGif;
/**
 Whether this instance stop gif.
 */
- (void)stopGif;

@end

NS_ASSUME_NONNULL_END
