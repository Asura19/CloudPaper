//
//  UIImage+Bundle.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bundle)
+ (UIImage *)imageNamedInResourceBundle:(NSString *)name;
@end
