//
//  UIBarButtonItem+CP.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CP)
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon
                  highligntedIcon:(NSString *)highligntedIcon
                           target:(id)target
                           action:(SEL)action;
@end
