//
//  AppDelegate.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/17.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "AppDelegate.h"
#import "CPNoteListController.h"
#import "CPNavigationController.h"
#import "UIView+CP.h"
#import "PHAudioTool.h"
#import "CPNoteEditController.h"
#import "CPMacro.h"
#import "CPNoteManager.h"
#import "CPNotificationManager.h"
#import "CPNote.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CPNoteListController *mainViewController = [[CPNoteListController alloc] init];
    CPNavigationController *nav = [[CPNavigationController alloc] initWithRootViewController:mainViewController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    UILocalNotification *noti = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (noti) {
        NSString * noteID = [noti.userInfo objectForKey:@"key"];
        CPNote *note = [[CPNoteManager sharedManager] readNoteWithNoteID:noteID];
        CPNoteEditController *detailedVc = [[CPNoteEditController alloc] initWithNote:note];
        [nav pushViewController:detailedVc animated:YES];
    } 
  
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"前台时的本地通知在此设置");
    NSLog(@"%@", notification.alertBody);
    
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    //  设置Locale，星期几会以中文显示
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    // 设定时间格式(后面跟 a,默认为中文)
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:notification.fireDate];
    
    NSLog(@"%@", dateString);
    
    if ([notification.fireDate timeIntervalSinceNow] > - 0.5) {
    
        NSString *content = notification.alertBody;
        NSString *remindLater = @"稍后提醒";
        NSString *cancel = @"朕知道了";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        // 10分钟后提醒
        UIAlertAction *remindLaterAction = [UIAlertAction actionWithTitle:remindLater style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // 创建本地通知、修改本地通知 或 删除本地通知
            NSString *noteID = [notification.userInfo objectForKey:@"key"];
            CPNote * note = [[CPNoteManager sharedManager] readNoteWithNoteID:noteID];
            
            // 删除旧通知，并重新注册新通知
            [[CPNotificationManager sharedManager] deleteLocalNotificationIfExist:note];
            note.remindDate = [note.remindDate dateByAddingTimeInterval:600];
            [[CPNotificationManager sharedManager] registLocalNotifiation:note];
            
            // 保存到本地
            [[CPNoteManager sharedManager] updateNote:note];
        }];
        
        UIAlertAction *contentAction = [UIAlertAction actionWithTitle:content style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString * noteID = [notification.userInfo objectForKey:@"key"];
            CPNote *note = [[CPNoteManager sharedManager] readNoteWithNoteID:noteID];
            CPNoteEditController *detailedVc = [[CPNoteEditController alloc] initWithNote:note];
            CPNoteListController *mainViewController = [self.window.rootViewController.childViewControllers firstObject];
            [mainViewController.navigationController pushViewController:detailedVc animated:YES];
            
        }];
        
        [alertController addAction:contentAction];
        [alertController addAction:remindLaterAction];
        [alertController addAction:cancelAction];
        [[UIView currentViewController] presentViewController:alertController animated:YES completion:nil];
    
        [PHAudioTool playSound:@"Tejat.wav"];
    }

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([[UIView currentViewController] isKindOfClass:[CPNoteEditController class]]) {
        NSLog(@"background");
        [[NSNotificationCenter defaultCenter] postNotificationName:SaveNoteWhenApplicationEnterBackground object:nil];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
