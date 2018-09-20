//
//  AppDelegate.m
//  BasicUtilsTest
//
//  Created by caobo56 on 2017/12/5.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import "AppDelegate.h"
#import "AboutAppManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AboutAppManager * ab = [AboutAppManager sharedManager];
    [ab setAuthorEmail:@"caobo56@126.com"];
    ab.appid = @"id1341244763";
    ab.appLinkTitle = @"'记笔记'，记录我们心底的点滴感动!";
    ab.appLinkDescription = @"'记笔记'是一款无后台的记事本app，通过麦克风可以方便的将您说的话转换成笔记文字内容，免去手机文字输入难用的烦恼。另外还可以通过邮件、剪贴版、分享到微信等方式发送笔记内容。";
    ab.appDescription = @"'记笔记'是一款无后台的记事本app，通过麦克风可以方便的将您说的话转换成笔记文字内容，免去手机文字输入难用的烦恼。另外还可以通过邮件、剪贴版、分享到微信等方式发送笔记内容。";
    ab.appIconName = @"iconbg";
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
