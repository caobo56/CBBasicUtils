//
//  CBAlertVC.h
//  CBBasicUtils
//
//  Created by caobo56 on 2019/7/30.
//

#import <UIKit/UIKit.h>

@class CBAlertVC;
typedef void(^CBAlertHandle)(CBAlertVC* _Nullable alertVC);

@interface CBAlertVC : UIView

+ (CBAlertVC *_Nullable)alertWithTitle:(NSString *_Nullable)title Message:(NSString *_Nullable)msg;

-(void)actionWithTitle:(NSString *_Nullable)title handle:(CBAlertHandle _Nullable )handle;

-(void)cancleActionWithTitle:(NSString *_Nullable)title handle:(CBAlertHandle _Nullable )handle;

-(void)showAt:(UIViewController *_Nullable)vc;

-(void)dismiss;

+(BOOL)isShow;

@end

