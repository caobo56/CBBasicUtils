//
//  CBBugReportVC.m
//  ZSCalendar
//
//  Created by caobo56 on 2018/9/20.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "CBBugReportVC.h"
#import "ViewController.h"
#import "AboutAppManager.h"

#import "CBBasicHeader.h"
#import "UIView+toast.h"

#import <Masonry.h>
#import <LFPhotoEditingController.h>

#define appName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

@interface CBBugReportVC ()<LFPhotoEditingControllerDelegate>

@end

@implementation CBBugReportVC

+(CBRootNavVC *)initializeWith:(UIImage *)image{
    CBBugReportVC * report = [[CBBugReportVC alloc]init];
    report.imageView.image = image;
    CBRootNavVC * nav = [[CBRootNavVC alloc]initWithRootViewController:report];
    return nav;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    [self addImageView];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addImageView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户bug反馈";
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self photoEditingWith:self.imageView.image];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)addImageView{
    self.imageView = [[UIImageView alloc]init];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view).multipliedBy(0.8);
    }];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                    initWithTitle:@"取消"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(cancelBtnAction)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]
                                  initWithTitle:@"保存截图"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(saveBtnAction)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"完成"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(doneButtonAction)];
    self.navigationItem.rightBarButtonItems = @[doneButton,saveBtn];
    
}

-(void)cancelBtnAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveBtnAction{
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    __block CBBugReportVC * blkself = self;
    [self.view toastSuccessMessage:@"保存成功！" complete:^{
        [blkself.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)doneButtonAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 图片处理
- (void)photoEditingWith:(UIImage *)image{
    LFPhotoEditingController *lfPhotoEditVC = [[LFPhotoEditingController alloc] init];
    lfPhotoEditVC.delegate = self;
    lfPhotoEditVC.editImage = self.imageView.image;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:lfPhotoEditVC animated:NO];
}

#pragma mark - LFPhotoEditingControllerDelegate
- (void)lf_PhotoEditingController:(LFPhotoEditingController *)photoEditingVC didCancelPhotoEdit:(LFPhotoEdit *)photoEdit
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)lf_PhotoEditingController:(LFPhotoEditingController *)photoEditingVC didFinishPhotoEdit:(LFPhotoEdit *)photoEdit
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.imageView.image = photoEdit.editPreviewImage;
    [self sendEMailWith:photoEdit.editPreviewImage];
}


#pragma mark - sendEMail
-(void)sendEMailWith:(UIImage *)img{
    ViewController * vc = [[ViewController alloc]init];
    [vc setMailTitle:[NSString stringWithFormat:@"'%@'用户bug反馈",appName]];
    [vc setMailText:@""];
    [vc setMailImageArr:@[img]];
    AboutAppManager * ab = [AboutAppManager sharedManager];
    [vc setMailTo:ab.authorEmail];
    WeakSelf
    [vc setMailBlock:^(NSString *text) {
        if ([text isEqualToString:@"SendEmailFail"]||[text isEqualToString:@"SendEmailCancelled"]) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf.view toastErrorMessage:@"邮件发送貌似有点问题哦，请检查邮箱配置或稍后重试！" complete:nil];
            });
        }else if ([text isEqualToString:@"SendEmailSuccess"]){
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf.view toastSuccessMessage:@"邮件发送成功，谢谢您的帮助！" complete:^{
                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
            });
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
