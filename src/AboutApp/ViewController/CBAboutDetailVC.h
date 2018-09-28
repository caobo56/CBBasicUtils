//
//  CBAboutDetailVC.h
//  BasicUtilsTest
//
//  Created by caobo56 on 2018/9/20.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "CBBasicVC.h"

@interface CBAboutDetailVC : CBBasicVC

@property(strong,nonatomic)NSString *appDescription;
@property(strong,nonatomic)NSString *appIconName;
//appIconName 这里放的是app 图标，必须放在bundle的根目录下，不能在Assets中

@end

