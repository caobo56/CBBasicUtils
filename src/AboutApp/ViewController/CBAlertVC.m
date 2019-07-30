//
//  CBAlertVC.m
//  CBBasicUtils
//
//  Created by caobo56 on 2019/7/30.
//

#import "CBAlertVC.h"
#import <Masonry.h>
#import <QuartzCore/QuartzCore.h>

#define WeakSelf __weak typeof(self) weakSelf = self;

@interface CBAlertView : UIView

@end

@implementation CBAlertView

@end

@interface CBAlertVC ()

@property (unsafe_unretained, nonatomic) IBOutlet CBAlertView *alertView;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLable;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contentLable;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *leftBtn;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *rightBtn;

@property(nonatomic,copy)CBAlertHandle leftHander;
@property(nonatomic,copy)CBAlertHandle rightHander;

@property(nonatomic,weak)UIViewController * vc;

@end

@implementation CBAlertVC

static CBAlertVC *DefaultManager = nil;

+ (CBAlertVC *)sharedAlertVC
{
    static CBAlertVC *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [self creatCBAlertVC];
    });
    return sharedInstance;
}

+(CBAlertVC *)creatCBAlertVC
{
    return (CBAlertVC *)[[[NSBundle mainBundle]loadNibNamed:@"CBAlertVC" owner:nil options:nil]lastObject];
}

+ (CBAlertVC *)alertWithTitle:(NSString *)title Message:(NSString *)msg{
    CBAlertVC * vc = [CBAlertVC sharedAlertVC];
    vc.titleLable.text = title;
    vc.contentLable.text = msg;
    return vc;
}

+(BOOL)isShow{
    CBAlertVC * vc = [CBAlertVC sharedAlertVC];
    if (vc.vc) {
        return YES;
    }
    return NO;
}


-(void)actionWithTitle:(NSString *_Nullable)title handle:(CBAlertHandle _Nullable )handle{
    [self.leftBtn setTitle:title forState:UIControlStateNormal];
    _leftHander = handle;
    [self.leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)leftBtnAction{
    WeakSelf
    if (_leftHander) {
        _leftHander(weakSelf);
    }
    [self dismiss];
}

-(void)cancleActionWithTitle:(NSString *_Nullable)title handle:(CBAlertHandle _Nullable )handle{
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
    _rightHander = handle;
    [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)rightBtnAction{
    WeakSelf
    if (_rightHander) {
        _rightHander(weakSelf);
    }
    [self dismiss];
}

-(void)showAt:(UIViewController *_Nullable)vc{
    [vc.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(vc.view);
        make.edges.equalTo(vc.view);
    }];
    
    [self exChangeOut:self.alertView dur:0.3];
    CGFloat msgHeight = [self calculateRowHeight:self.contentLable.text fontSize:15.0f];
    [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(msgHeight);
    }];
    [self.alertView layoutSubviews];
    [self.alertView layoutIfNeeded];
    [self layoutSubviews];
    [self layoutIfNeeded];
    self.vc = vc;
}

-(void)dismiss{
    [self removeFromSuperview];
    self.vc = nil;
}

-(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [changeOutView.layer addAnimation:animation forKey:nil];
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.alertView.frame.size.width-16, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height+5+10+20+10;
}

@end
