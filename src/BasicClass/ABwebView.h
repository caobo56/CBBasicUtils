//
//  ABwebView.h
//  ABCreditApp
//
//  Created by caobo56 on 2017/7/25.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import "CBBasicVCHeader.h"

@interface ABwebView : ABBasicVC

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *url;

@end
