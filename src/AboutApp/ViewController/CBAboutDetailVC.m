//
//  CBAboutDetailVC.m
//  BasicUtilsTest
//
//  Created by caobo56 on 2018/9/20.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "CBAboutDetailVC.h"

@interface CBAboutDetailVC ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UITextView *descTxtView;

@end

@implementation CBAboutDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _iconImgView.image = [UIImage imageNamed:_appIconName];
    _descTxtView.text = _appDescription;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
