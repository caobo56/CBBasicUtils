//
//  NSString+URL.m
//  MeiDouLive
//
//  Created by caobo56 on 2016/11/14.
//  Copyright © 2016年 caobo56. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSString *)URLEncodedString
{
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedString;
}

- (NSString *)URLDecodedString{
    NSString *decodedString  = [self stringByRemovingPercentEncoding];
    return decodedString;
}

@end
