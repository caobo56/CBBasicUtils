//
//  CBViewController.m
//  BasicUtilsTest
//
//  Created by caobo56 on 2018/9/20.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "CBViewController.h"

#import <AFNetworking.h>
#import "CBAPIHeader.h"

@interface CBViewController ()

@end

@implementation CBViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)aboutAction:(id)sender {
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

//    [manager POST:@"http://apis.juhe.cn/simpleWeather/query" parameters:@{@"city":@"苏州",@"key":@"d305349b95b9b3caea56baf348b8afd2"} progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject = %@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    }];
    
    CBAPIClient * client = [CBAPIClient client];
    client.responseSerializer = [CBAPIResponseJsonSerializer serializer];
    
    [client postUrl:@"http://apis.juhe.cn/simpleWeather/query" params:@{@"city":@"苏州",@"key":@"d305349b95b9b3caea56baf348b8afd2"} success:^(NSURLSessionDataTask * _Nullable sessionTask, id  _Nonnull data) {
        NSLog(@"data = %@",data);
    } failure:^(NSURLSessionDataTask * _Nullable sessionTask, NSError * _Nonnull error) {
        
    }];
    
    
//    CBAPIClient * client = [CBAPIClient client];
//
//    client.requestSerializer = [CBAPIRequestJsonSerializer serializer];
//    [client.requestSerializer setAuthorizationHeaderFieldWithUsername:@"uc-portal-dat" password:@"admin"];
//
//    client.responseSerializer = [CBAPIResponseJsonSerializer serializer];
//
//    [client postUrl:@"http://10.7.91.214:9000/api/oauth/token"
//             params:@{
//                      @"username":@"aduser1",
//                      @"password":@"abic@123",
//                      @"grant_type":@"password"
//                      }
//            success:^(NSURLSessionDataTask * _Nullable sessionTask, id  _Nonnull data) {
//                NSLog(@"data = %@",data);
//            }
//            failure:^(NSURLSessionDataTask * _Nullable sessionTask, NSError * _Nonnull error) {
//                NSLog(@"error = %@",error);
//            }];
    
//    CBAboutTableVC * about = [[UIStoryboard storyboardWithName:@"About" bundle:nil] instantiateViewControllerWithIdentifier:@"CBAboutTableVC"];
//    [self.navigationController pushViewController:about animated:YES];
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
