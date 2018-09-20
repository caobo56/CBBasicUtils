//
//  CBBugReportVC.h
//  ZSCalendar
//
//  Created by caobo56 on 2018/9/20.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "CBBasicVC.h"
#import "CBRootNavVC.h"

typedef void(^MailCallBack) (NSString *text);

@interface CBBugReportVC : CBBasicVC

@property(strong,nonatomic)UIImageView * imageView;

+(CBRootNavVC *)initializeWith:(UIImage *)image;

@end

