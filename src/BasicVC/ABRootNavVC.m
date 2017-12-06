//
//  ABRootNavVC.m
//  ABCreditApp
//
//  Created by caobo56 on 2017/2/14.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import "ABRootNavVC.h"

#define RGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface ABRootNavVC ()

@end

@implementation ABRootNavVC

-(void)awakeFromNib{
    [super awakeFromNib];
    UIColor * color = RGB16(0x515151);
    NSDictionary * dict = @{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
    self.navigationBar.titleTextAttributes = dict;
}


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        UIColor * color = RGB16(0x515151);
        NSDictionary * dict = @{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
        self.navigationBar.titleTextAttributes = dict;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationControllerAppearance];
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationControllerAppearance {
    [UINavigationBar appearance].barStyle  = UIBarStyleDefault;

    [self.navigationBar setTintColor:RGB16(0x9e9e9e)];
    
    //    //自定义返回按钮
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back"];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
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
