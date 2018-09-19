//
//  CBShareView.h
//  ZSCalendar
//
//  Created by caobo56 on 2018/9/7.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareType){
    ShareNone = 1001,
    ShareToCircle,
    ShareToFriend
};

typedef void (^CBShareViewHandler)(ShareType);


@interface CBShareView : UIView

+(CBShareView *)showWithSuperView:(UIView *)superView;

@property (nonatomic, copy) CBShareViewHandler shareHandler;


@end
