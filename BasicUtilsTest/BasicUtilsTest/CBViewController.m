//
//  CBViewController.m
//  BasicUtilsTest
//
//  Created by caobo56 on 2018/9/20.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "CBViewController.h"
#import "AboutAppManager.h"

@interface CBViewController ()

@end

@implementation CBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)aboutAction:(id)sender {
    CBAboutTableVC * about = [[UIStoryboard storyboardWithName:@"About" bundle:nil] instantiateViewControllerWithIdentifier:@"CBAboutTableVC"];
    [self.navigationController pushViewController:about animated:YES];
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
