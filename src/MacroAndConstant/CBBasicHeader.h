//
//  CBBasicHeader.h
//  ABCreditApp
//
//  Created by caobo56 on 2017/2/14.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#ifndef CBBasicHeader_h
#define CBBasicHeader_h

#define UI_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define UI_IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREENSIZE_IS_35  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define SCREENSIZE_IS_40  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define SCREENSIZE_IS_47  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define SCREENSIZE_IS_55  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0)

//判断iPHoneXr
#define SCREENSIZE_IS_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断iPHoneX、iPHoneXs
#define SCREENSIZE_IS_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define SCREENSIZE_IS_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

//判断iPhoneXs Max
#define SCREENSIZE_IS_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)

#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

//状态栏、导航栏、标签栏高度
#define Height_NavContentBar 44.0f

#define Height_StatusBar (IS_IPhoneX_All ? 44.0 : 20.0)

#define Height_NavBar (IS_IPhoneX_All ? 88.0 : 64.0)

#define Height_TopBar (Height_StatusBar + Height_NavBar)

#define Height_TapBar (IS_IPhoneX_All ? 83.0 : 49.0)

#define SCREEN_HEIGHTL [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTHL [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define RGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]


#define WeakSelf __weak typeof(self) weakSelf = self;

#endif /* CBBasicHeader_h */
