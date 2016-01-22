//
//  UIView+CP.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/22.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CP)
/**
 *  获取当前控制器的父控制器
 */
- (UIViewController *)parentController;
/**
 *  获取当前控制器
 */
+ (UIViewController *)currentViewController;
@end
