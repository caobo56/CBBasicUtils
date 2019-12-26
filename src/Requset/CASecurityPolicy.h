//
//  CASecurityPolicy.h
//  BasicUtilsTest
//
//  Created by caobo56 on 2019/12/26.
//  Copyright © 2019 caobo56. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol policyCustomComp <NSObject>

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler;

@end

@interface CASecurityPolicy : NSObject

@property(nonatomic,assign) BOOL policyIsActive;
@property(nonatomic,assign) BOOL policyIsDefault;
@property(nonatomic,weak) id<policyCustomComp> delegate;

@end

/**************************************************/
/**
 安全策略说明
 初始状态下，policyIsActive = NO
 这时，直接无条件信任服务器HTTPS证书
 如果使用者将policyIsActive = YES，
 但不修改policyIsDefault = NO，则 policyIsDefault 默认为 YES，
 则此时仍然 无条件信任服务器HTTPS证书
 如果修改policyIsDefault = NO，
 则此时先判断 delegate 是否为nil
 不为nil，则根据使用者设置的 delegate ，来确认安全策略
 为nil，则拒绝本次请求，打印出拒绝原因，下次请求继续确认。
 */

NS_ASSUME_NONNULL_END
