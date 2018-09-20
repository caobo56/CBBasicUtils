//
//  ViewController.m
//  CBMailTest
//
//  Created by caobo56 on 2018/1/27.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "ViewController.h"

@import MessageUI;

@interface ViewController () <MFMailComposeViewControllerDelegate>

@end
@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mailTitle = @"邮件主题";
        _mailText = @"邮件内容";
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _mailTitle = @"邮件主题";
    _mailText = @"邮件内容";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.01];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)delayMethod{
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"不能发送邮件" message:@"请检查邮件设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.mailBlock) {
                    self.mailBlock(NSLocalizedString(@"SendEmailFail", @""));
                }
            }];
        }];
        [actionSheet addAction:action];
        [self presentViewController:actionSheet animated:YES completion:nil];
        return;
    }
    [self sendMailAction:nil];
}

- (IBAction)sendMailAction:(id)sender {
    // 1.初始化编写邮件的控制器
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    if (![MFMailComposeViewController canSendMail]) {
        if (_mailBlock) {
//            _mailBlock(@"设备还没有添加邮件账户");
            _mailBlock(NSLocalizedString(@"SendEmailFail", @""));
            return;
        }
    }
    
    if (!mailPicker) {
        // 在设备还没有添加邮件账户的时候mailPicker为空，
        // 下面的present view controller会导致程序崩溃，这里要作出判断
        if (_mailBlock) {
//            _mailBlock(@"设备还没有添加邮件账户");
            _mailBlock(NSLocalizedString(@"SendEmailFail", @""));
            return;
        }
    }
    
    mailPicker.mailComposeDelegate = self;
    
    // 2.设置邮件主题
    if (_mailTitle) {
        [mailPicker setSubject:_mailTitle];
    }
    
    if (_mailText) {
        // 3.设置邮件主体内容
        [mailPicker setMessageBody:_mailText isHTML:NO];
    }
    
    if (_mailTo) {
        NSArray *toRecipients = [NSArray arrayWithObject:_mailTo];
        [mailPicker setToRecipients:toRecipients];
    }
    
    if (_mailImageArr && _mailImageArr.count > 0) {
        for (UIImage * img in _mailImageArr) {
            NSData *imageData = UIImagePNGRepresentation(img);
            [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
        }
    }
    
    // 5.呼出发送视图
    [self presentViewController:mailPicker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString * res = @"";
    switch (result) {
        case MFMailComposeResultFailed:
            res = @"SendEmailFail";
            break;
        case MFMailComposeResultSent:
            res = @"SendEmailSuccess";
            break;
        case MFMailComposeResultCancelled:
            res = @"SendEmailCancelled";
            break;
        case MFMailComposeResultSaved:
            res = @"SendEmailSaved";
            break;
        default:
            break;
    }
    __weak ViewController * blkvc = self;
    if (_mailBlock) {
        blkvc.mailBlock(NSLocalizedString(res, @""));
    }
    //关闭邮件发送窗口
    [controller dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}

@end

