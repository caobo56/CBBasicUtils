//
//  CBAboutTableVC.m
//  ZSCalendar
//
//  Created by caobo56 on 2018/9/18.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "CBAboutTableVC.h"
#import "CBAboutDetailVC.h"
#import "AboutAppManager.h"
#import "ViewController.h"

#import <StoreKit/StoreKit.h>

#import "CBBasicHeader.h"
#import "UIView+toast.h"

#import <WXApi.h>

#define appName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

@interface CBAboutTableVC ()

@property (weak, nonatomic) IBOutlet UILabel *aboutlable;

@end

@implementation CBAboutTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _aboutlable.text = self.title = [NSString stringWithFormat:@"关于'%@'",appName];
    AboutAppManager * ab = [AboutAppManager sharedManager];
    _appid = ab.appid;
    _appLinkTitle = ab.appLinkTitle;
    _appLinkDescription = ab.appLinkDescription;
    _appDescription = ab.appDescription;
    _appIconName = ab.appIconName;
    _authorEmail = ab.authorEmail;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"返回"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(backItemAction)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
}

-(void)backItemAction{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationItem setHidesBackButton:NO];
    [self.navigationItem setHidesBackButton:NO];
    [self.navigationController.navigationBar.backItem setHidesBackButton:NO];
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
            case 0:
            [self sendMailForHelp];
            break;
            case 1:
            [self sendMailFeedBack];
            break;
            case 2:
            [self shareToWeiXin];
            break;
            case 3:
            [self AddContent];
            break;
            case 4:
            [self aboutDetail];
            break;
        default:
            break;
    }
}

-(void)sendMailForHelp{
    ViewController * vc = [[ViewController alloc]init];
    [vc setMailTitle:[NSString stringWithFormat:@"'%@'用户申请帮助",appName]];
    [vc setMailText:@""];
    [vc setMailTo:_authorEmail];
    WeakSelf
    [vc setMailBlock:^(NSString *text) {
        if ([text isEqualToString:@"SendEmailFail"]||[text isEqualToString:@"SendEmailCancelled"]) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf.view toastMessage:@"邮件发送貌似有点问题哦，请检查邮箱配置或稍后重试！"];
            });
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)sendMailFeedBack{
    ViewController * vc = [[ViewController alloc]init];
    [vc setMailTitle:[NSString stringWithFormat:@"'%@'用户意见反馈",appName]];
    [vc setMailText:@""];
    [vc setMailTo:_authorEmail];
    WeakSelf
    [vc setMailBlock:^(NSString *text) {
        if ([text isEqualToString:@"SendEmailFail"]||[text isEqualToString:@"SendEmailCancelled"]) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf.view toastMessage:@"邮件发送貌似有点问题哦，请检查邮箱配置或稍后重试！"];
            });
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)shareToWeiXin{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        NSString *kLinkURL = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/%@",_appid];
        NSString *kLinkTitle = _appLinkTitle;
        NSString *kLinkDescription = _appLinkDescription;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        // 是否是文档
        req.bText = NO;
        req.scene = WXSceneSession;
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = kLinkTitle;//分享标题
        urlMessage.description = kLinkDescription;//分享描述
        [urlMessage setThumbImage:[UIImage imageNamed:_appIconName]];
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = kLinkURL;//分享链接
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        req.message = urlMessage;
        //发送分享信息
        [WXApi sendReq:req completion:^(BOOL success) {
            
        }];
    }else{
        //        [self.view toastMessage:@"您的手机未安装微信，暂时不能使用该功能！"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *kLinkURL = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/%@",_appid];
        pasteboard.string = kLinkURL;
        [self.view toastSuccessMessage:@"已经复制该app的链接到剪贴板，可以去粘贴链接，推荐给好友！" complete:nil];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
// 要消息的代码块
-(void)AddContent{
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    } else {
        NSString * nsStringToOpen = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/%@?mt=8",_appid];//替换为对应的APPID
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
    }
}
// 被夹在这中间的代码针对于此警告都会无视并且不显示出来
#pragma clang diagnostic pop


-(void)aboutDetail{
    CBAboutDetailVC * about = [[UIStoryboard storyboardWithName:@"About" bundle:nil] instantiateViewControllerWithIdentifier:@"CBAboutDetailVC"];
    about.appIconName = _appIconName;
    about.appDescription = _appDescription;
    about.title = [NSString stringWithFormat:@"关于'%@'",appName];
    [self.navigationController pushViewController:about animated:YES];
}

@end
