//
//  CPNavigationController.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNavigationController.h"
#import "CPMacro.h"
#import "UIBarButtonItem+CP.h"

@interface CPNavigationController ()

@end

@implementation CPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"barbuttonicon_back"
                                                                    highligntedIcon:@"nothing"
                                                                             target:self
                                                                             action:@selector(back)];
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}
@end
