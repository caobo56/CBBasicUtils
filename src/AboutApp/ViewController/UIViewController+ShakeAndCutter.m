//
//  UIViewController+ShakeAndCutter.m
//  ZSCalendar
//
//  Created by caobo56 on 2018/9/18.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "UIViewController+ShakeAndCutter.h"

#import <QuartzCore/QuartzCore.h>

#import "CBBugReportVC.h"
#import "CBAlertVC.h"


@implementation UIViewController (ShakeAndCutter)

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 摇一摇动作处理

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"began");
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"cancel");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"end");
    if ([CBAlertVC isShow]) {
        return;
    }
    
    UIImage * img = [self cutterViewToDocument];
    __block UIImage * blkImg = img;
    
    CBAlertVC * alertVC = [CBAlertVC alertWithTitle:@"摇一摇反馈错误" Message:@"当前页面截图,将通过邮件反馈给开发者，谢谢您的配合！"];
    
    [alertVC actionWithTitle:@"确定" handle:^(CBAlertVC * _Nullable alertVC) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self bugReportWith:blkImg];
        });
        
    }];
    
    [alertVC cancleActionWithTitle:@"误操作了" handle:^(CBAlertVC * _Nullable alertVC) {
        
    }];
    
    [alertVC showAt:self];
}

#pragma mark - 截屏处理

- (UIImage *)cutterViewToDocument
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot;
    //    NSData *screenShotPNG = UIImagePNGRepresentation(screenShot);
    //    NSError *error = nil;
    //    [screenShotPNG writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"sc_error.png"] options:NSAtomicWrite error:&error];
}


#pragma mark - BugReport
-(void)bugReportWith:(UIImage *)image{
    CBRootNavVC * report = [CBBugReportVC initializeWith:image];
    if (self.navigationController) {
        [self.navigationController presentViewController:report animated:NO completion:nil];
    }else{
        [self presentViewController:report animated:NO completion:nil];
    }
}

@end
