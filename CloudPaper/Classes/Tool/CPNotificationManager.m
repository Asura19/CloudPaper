//
//  CPNotificationManager.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/23.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNotificationManager.h"
#import "CPNote.h"
#import "CPNoteManager.h"
#import <UIKit/UIKit.h>

@implementation CPNotificationManager

+ (instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

/**
 *  @return 返回是否需要(重新)注册本地通知，添加闹钟提醒
 */
- (BOOL)shouldRegistLocalNotifiation:(CPNote *)note {
    if (!note.remindDate) {
        return NO;
    } else {
        CPNote *diskNote = [[CPNoteManager sharedManager] readNoteWithNoteID:note.noteID];
        // 如果提醒时间或者文本内容改了，都需要删除旧通知，重新发送通知
        if ((note.remindDate == diskNote.remindDate) && [note.content isEqualToString:diskNote.content]) {
            return NO;
        } else {
            return YES;
        }
    }
}

/**
 *  创建本地通知
 */
- (void)registLocalNotifiation:(CPNote *)note {
    // 注册通知
    UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    
    // 2.设置通知属性
    // 音效文件名
    noti.soundName = @"Tejat.wav";
    
    // 通知的具体内容 content的前四十个字
    noti.alertBody = [note.content length] > 40 ? [note.content substringWithRange:NSMakeRange(0, 40)] : note.content;
    
    // 锁屏界面显示的小标题（"滑动来" + alertAction）
    noti.alertAction = @"查看";
    
    // 通知第一次发出的时间
    noti.fireDate = note.remindDate;
    // 设置时区（跟随手机的时区）
    noti.timeZone = [NSTimeZone defaultTimeZone];

    
    // 设置通知的额外信息
    noti.userInfo = @{
                    @"key" : note.noteID
                    };
    
    // 设置启动图片
    noti.alertLaunchImage = @"Default";
    
    
    // 3.调度通知（启动任务）
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
 
}

- (void)deleteLocalNotificationIfExist:(CPNote *)note {
    //拿到 存有 所有 推送的数组
    NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //便利这个数组 根据 key 拿到我们想要的 UILocalNotification
    for (UILocalNotification * noti in array) {
        if ([[noti.userInfo objectForKey:@"key"] isEqualToString:note.noteID]) {
            //取消 本地推送
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
        }
    }
}

@end
