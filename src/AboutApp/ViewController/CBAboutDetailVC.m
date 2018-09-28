//
//  CBAboutDetailVC.m
//  BasicUtilsTest
//
//  Created by caobo56 on 2018/9/20.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "CBAboutDetailVC.h"

@interface CBAboutDetailVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CBAboutDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self laodWebView];
}

-(void)laodWebView{
    NSMutableString * str = [NSMutableString stringWithFormat:@"<!DOCTYPE html><html lang=\"zh-cn\"><head>    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>    <style type=\"text/css\">.content{color:#383131;font-size:18px;margin-top:7px;margin-left:20px;margin-right:20px}        .gird{margin-top:50px}</style></head><body><div class=\"gird\" align=\"center\"><img src=\"data:image/png;base64,"];
    NSString *imgStr = [self image2String:[UIImage imageNamed:_appIconName]];
    [str appendString:imgStr];
    [str appendString:@"\" height=\"100\" width=\"100\"/></img></div><dl style=\"text-indent: 2em;text-align:left;\"><dt class=\"content\"> "];
    [str appendString:_appDescription];
    [str appendString:@"</dt></dl><div class=\"gird\"></div></body></html>"];
    [_webView loadHTMLString:str baseURL:nil];
}


- (NSString *) image2String:(UIImage *)image {
    NSData *pictureData = UIImageJPEGRepresentation(image, 1.0);
    NSString *pictureDataString = [pictureData base64EncodedStringWithOptions:0];
    return pictureDataString;
}


@end
