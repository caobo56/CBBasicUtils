//
//  MentoreUitls.m
//  CorderAlmanac
//
//  Created by caobo56 on 2017/12/1.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import "MentoreUitls.h"

@implementation MentoreUitls


+(NSInteger)randomByDay{
//    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
//    date = [DateUtils dateToDay:date];
//    long th = [date timeIntervalSince1970];
//    srand((unsigned)time(&th));
    return  rand();
}

@end
