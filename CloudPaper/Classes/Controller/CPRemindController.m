//
//  CPRemindController.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/22.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPRemindController.h"
#import "CPMacro.h"
#import "UIBarButtonItem+CP.h"
#import "Masonry.h"
#import "UIImage+Phoenix.h"

@interface CPRemindController ()
{
    UIDatePicker *_datePicker;
    UIButton *_deleteButton;
}

@end

@implementation CPRemindController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationItems];
    [self initSubViews];
    
    [self registLocalNotifiation];

}

- (void)setupNavigationItems {
    // setup navigationbar title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:NAVIGATIONBAR_SETTING_TITLE_FONT_SIZE];
    titleLabel.text = @"添加提醒";
    titleLabel.textColor = [UIColor whiteColor];
    CGSize titleLabelSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:NAVIGATIONBAR_SETTING_TITLE_FONT}];
    titleLabel.frame = (CGRect){{0, 0}, titleLabelSize};
    self.navigationItem.titleView = titleLabel;
    // setup navigationbar right item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"存储" style:UIBarButtonItemStylePlain target:self action:@selector(saveRemind)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}



- (void)initSubViews {
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.view addSubview:_datePicker];
    
//    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    _deleteButton = [[UIButton alloc] init];
    [_deleteButton setBackgroundImage:[UIImage resizedImageNamed:@"delete_warning"] forState:UIControlStateNormal];
    [_deleteButton setBackgroundImage:[UIImage resizedImageNamed:@"delete_warning_highlighted"] forState:UIControlStateHighlighted];
    [_deleteButton setBackgroundImage:[UIImage resizedImageNamed:@"delete_warning_disable"] forState:UIControlStateDisabled];
    
    
    UILabel *deleteLabel = [[UILabel alloc] init];
    deleteLabel.font = [UIFont systemFontOfSize:20];
    deleteLabel.text = @"删     除";
    deleteLabel.textColor = [UIColor whiteColor];

    CGSize deleteLabelSize = [deleteLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    [_deleteButton addSubview:deleteLabel];
    [self.view addSubview:_deleteButton];
    
    [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_deleteButton.mas_centerX);
        make.centerY.equalTo(_deleteButton.mas_centerY);
        make.width.equalTo(@(deleteLabelSize.width));
        make.height.equalTo(@(deleteLabelSize.height));
    }];
    
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.width.equalTo(@300);
        make.height.equalTo(@200);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_datePicker.mas_bottom).offset(100);
        make.width.equalTo(@300);
        make.height.equalTo(@50);
    }];

}

- (void)registLocalNotifiation {
    // 注册通知
    UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];
    
    
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    
    // 2.设置通知属性
    // 音效文件名
    ln.soundName = @"Tejat.wav";
    
    // 通知的具体内容
    ln.alertBody = @"This is a LocalNotification Test";
    
    // 锁屏界面显示的小标题（"滑动来" + alertAction）
    ln.alertAction = @"查看便签吧";
    
    // 通知第一次发出的时间(5秒后发出)
    ln.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    // 设置时区（跟随手机的时区）
    ln.timeZone = [NSTimeZone defaultTimeZone];
    
    // 设置app图标数字
    ln.applicationIconBadgeNumber = 5;
    
    // 设置通知的额外信息
    ln.userInfo = @{
                    @"icon" : @"test.png",
                    @"title" : @"重大新闻",
                    @"time" : @"2014-08-14 11:19",
                    @"body" : @"重大新闻:答复后即可更换就肯定会尽快赶快回家的疯狂估计很快将发的"
                    };
    
    // 设置启动图片
    ln.alertLaunchImage = @"Default";
    
    // 设置重复发出通知的时间间隔
    //    ln.repeatInterval = NSCalendarUnitMinute;
    
    // 3.调度通知（启动任务）
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
}

- (void)saveRemind {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
