//
//  CBAPIClient.h
//  BasicUtilsTest
//
//  Created by caobo56 on 2019/8/5.
//  Copyright © 2019 caobo56. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBAPISerializer.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^NetworkCompletion)(NSError* error,id data);

typedef void(^NetworkProgressHandler)(NSProgress * progress);
typedef void(^NetworkSuccessHandler)(NSURLSessionDataTask * __nullable sessionTask,id data);
typedef void(^NetworkFailureHandler)(NSURLSessionDataTask * __nullable sessionTask,NSError* error);

@interface CBAPIClient : NSObject

@property (nonatomic, strong) CBAPIRequestSerializer * requestSerializer;

@property (nonatomic, strong) CBAPIResponseSerializer * responseSerializer;

@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;

#pragma  - mark Setting

+ (instancetype)client;

- (instancetype)initWithBaseURL:(NSURL * __nullable)url;

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration * __nullable)configuration;

- (instancetype)initWithBaseURL:(NSURL *__nullable)url
           sessionConfiguration:(NSURLSessionConfiguration *__nullable)configuration;

#pragma  - mark SendUrl
-(void)sendUrl:(NSString * __nonnull)url
        method:(NSString * __nonnull)method
        params:(NSDictionary * __nonnull)params
    upProgress:(NetworkProgressHandler __nullable)upProgress
  downProgress:(NetworkProgressHandler __nullable)downProgress
       success:(NetworkSuccessHandler __nonnull)success
       failure:(NetworkFailureHandler __nonnull)failure;

#pragma  - mark SubSendUrl
-(void)getUrl:(NSString * )url
       params:(NSDictionary * )params
      success:(NetworkSuccessHandler)success
      failure:(NetworkFailureHandler)failure;

-(void)postUrl:(NSString * )url
       params:(NSDictionary * )params
      success:(NetworkSuccessHandler)success
      failure:(NetworkFailureHandler)failure;

-(void)deleteUrl:(NSString * )url
          params:(NSDictionary * )params
         success:(NetworkSuccessHandler)success
         failure:(NetworkFailureHandler)failure;

-(void)headUrl:(NSString * )url
        params:(NSDictionary * )params
       success:(NetworkSuccessHandler)success
       failure:(NetworkFailureHandler)failure;

-(void)putUrl:(NSString * )url
       params:(NSDictionary * )params
      success:(NetworkSuccessHandler)success
      failure:(NetworkFailureHandler)failure;

-(void)patchUrl:(NSString * )url
         params:(NSDictionary * )params
        success:(NetworkSuccessHandler)success
        failure:(NetworkFailureHandler)failure;
@end

NS_ASSUME_NONNULL_END
