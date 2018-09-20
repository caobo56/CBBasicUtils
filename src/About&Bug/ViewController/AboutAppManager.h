//
//  AboutAppManager.h
//  BasicUtilsTest
//
//  Created by caobo56 on 2018/9/20.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBAboutTableVC.h"

@interface AboutAppManager : NSObject

@property(strong,nonatomic)NSString *appid;
@property(strong,nonatomic)NSString *appLinkTitle;
@property(strong,nonatomic)NSString *appLinkDescription;
@property(strong,nonatomic)NSString *appDescription;
@property(strong,nonatomic)NSString *appIconName;
@property(strong,nonatomic)NSString *authorEmail;

+ (AboutAppManager *)sharedManager;

@end

