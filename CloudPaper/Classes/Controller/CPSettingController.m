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
#import "ProgressHUD.h"

@interface CPSettingController ()
@property (nonatomic, strong) NSMutableArray *settingItems;
@end

@implementation CPSettingController

- (NSMutableArray *)settingItems {
    if (!_settingItems) {
        NSString *one = @"同步云端便签";
        NSString *two = @"启用Markdown模式";
        NSString *three = @"便签回收站";
        NSString *four = @"Touch ID 和密码";
        NSString *five = @"意见和建议";
        _settingItems = [NSMutableArray arrayWithObjects:one, two, three, four, five, nil];
    }
    return _settingItems;
}

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = self.settingItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [ProgressHUD showError:@"Coming Soon..."];
}

@end
