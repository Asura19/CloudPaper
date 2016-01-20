//
//  UIImage+Phoenix.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/20.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Phoenix)
+ (UIImage *)resizedImageNamed:(NSString *)name;
+ (UIImage *)resizedImageNamed:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

+ (UIImage *)imageNamedInResourceBundle:(NSString *)name;
@end
