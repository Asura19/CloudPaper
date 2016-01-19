//
//  CPSettingController.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/20.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPSettingController.h"
#import "CPMacro.h"
#import "UIBarButtonItem+CP.h"

@implementation CPSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItems];
}

- (void)setupNavigationItems {
    // setup navigationbar title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:NAVIGATIONBAR_SETTING_TITLE_FONT_SIZE];
    titleLabel.text = @"设置";
    titleLabel.textColor = [UIColor whiteColor];
    CGSize titleLabelSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:NAVIGATIONBAR_SETTING_TITLE_FONT}];
    titleLabel.frame = (CGRect){{0, 0}, titleLabelSize};
    self.navigationItem.titleView = titleLabel;
    // setup navigationbar right item
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"HeadImgSelectIcon"
                                                           highligntedIcon:@"nothing"
                                                                    target:self
                                                                    action:@selector(close)];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
