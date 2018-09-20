//
//  ViewController.h
//  CBMailTest
//
//  Created by caobo56 on 2018/1/27.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MailCallBack) (NSString *text);

@interface ViewController : UIViewController

@property(strong,nonatomic)NSString * mailTitle;

@property(strong,nonatomic)NSString * mailText;

@property(strong,nonatomic)NSString * mailTo;

@property(strong,nonatomic)NSArray<UIImage *>* mailImageArr;

@property (nonatomic,copy)MailCallBack mailBlock;

@end

