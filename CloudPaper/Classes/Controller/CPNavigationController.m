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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
