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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CPNoteListController *mainViewController = [[CPNoteListController alloc] init];
    CPNavigationController *nav = [[CPNavigationController alloc] initWithRootViewController:mainViewController];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"前台时的本地通知在此设置");
    
    
//    NSString *cancelButtonTitle = @"取消";
//    NSString *takePhotoTitle = @"拍摄照片";
//    NSString *choosePhotoTitle = @"选择照片";
//    NSString *drawPictureTitle = @"手绘图片";
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    
//    // Create the actions.
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
//    }];
//    
//    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        NSLog(@"The \"Okay/Cancel\" alert action sheet's destructive action occured.");
//    }];
//    
//    UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:choosePhotoTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        NSLog(@"The \"Okay/Cancel\" alert action sheet's destructive action occured.");
//    }];
//    
//    UIAlertAction *drawPictureAction = [UIAlertAction actionWithTitle:drawPictureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        NSLog(@"The \"Okay/Cancel\" alert action sheet's destructive action occured.");
//    }];
//    
//    [alertController addAction:cancelAction];
//    [alertController addAction:drawPictureAction];
//    [alertController addAction:choosePhotoAction];
//    [alertController addAction:takePhotoAction];
//    
////    [[[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers lastObject] presentViewController:alertController animated:YES completion:nil];
//    [[UIView currentViewController] presentViewController:alertController animated:YES completion:nil];
//    [PHAudioTool playSound:@"Tejat.wav"];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
