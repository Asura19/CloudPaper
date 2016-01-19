//
//  CPBaseNavigationController.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/20.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPBaseNavigationController.h"
#import "CPMacro.h"

@implementation CPBaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置状态栏样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
