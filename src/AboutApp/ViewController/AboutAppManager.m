//
//  AboutAppManager.m
//  BasicUtilsTest
//
//  Created by caobo56 on 2018/9/20.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "AboutAppManager.h"

@implementation AboutAppManager

static AboutAppManager *DefaultManager = nil;

+ (AboutAppManager *)sharedManager
{
    static AboutAppManager *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}



@end
