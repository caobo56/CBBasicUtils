//
//  CBInputView.m
//  QMB
//
//  Created by LC_MAC-1 on 14-8-28.
//  Copyright (c) 2014年 MLJ. All rights reserved.
//

#import "CBInputView.h"

@implementation CBInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(CBInputView *)creatInputView
{
  return [[[NSBundle mainBundle]loadNibNamed:@"CBInputView" owner:nil options:nil]lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
