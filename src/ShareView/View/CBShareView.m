//
//  CBShareView.m
//  ZSCalendar
//
//  Created by caobo56 on 2018/9/7.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "CBShareView.h"

#import "CBBasicHeader.h"
#import "Masonry.h"
#import "CoreAnimationEffect.h"

@interface CBShareView()

@property (weak, nonatomic) IBOutlet UIView *touchView;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *panelView;

@end


@implementation CBShareView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.backgroundColor = RGBAlpha(0x000000, 0.5);
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_touchView addGestureRecognizer:singleTap];
    
    UISwipeGestureRecognizer * swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [_touchView addGestureRecognizer:swipeDown];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    self.hidden = YES;
    [self removeFromSuperview];
}

+(CBShareView *)showWithSuperView:(UIView *)superView{
    CBShareView * shareView = [[[NSBundle mainBundle]loadNibNamed:@"CBShareView" owner:nil options:nil]lastObject];
    shareView.hidden = NO;
    [superView addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTHL, SCREEN_HEIGHTL));
        make.bottom.equalTo(superView.mas_bottom);
        make.centerX.equalTo(superView.mas_centerX);
    }];
    [shareView bottomViewAnimation];
    return shareView;
}

-(void)bottomViewAnimation{
    [CoreAnimationEffect animationMoveUp:_panelView duration:0.25f];
}

- (IBAction)friendcircleAction:(id)sender {
    if (_shareHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_shareHandler(ShareToCircle);
        });
    }
}

- (IBAction)weixinAction:(id)sender {
    if (_shareHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shareHandler(ShareToFriend);
        });
    }
}

@end
