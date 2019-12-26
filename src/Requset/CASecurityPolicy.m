//
//  CASecurityPolicy.m
//  BasicUtilsTest
//
//  Created by caobo56 on 2019/12/26.
//  Copyright © 2019 caobo56. All rights reserved.
//

#import "CASecurityPolicy.h"

@implementation CASecurityPolicy
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.policyIsActive = NO;
    }
    return self;
}

- (void)setPolicyIsActive:(BOOL)policyIsActive{
    if (policyIsActive) {
        self.policyIsDefault = YES;
    }
}

@end
