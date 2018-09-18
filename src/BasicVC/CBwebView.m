//
//  CBwebView.m
//  ABCreditApp
//
//  Created by caobo56 on 2017/7/25.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import "CBwebView.h"

@interface CBwebView ()

@end

@implementation CBwebView

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc]initWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
