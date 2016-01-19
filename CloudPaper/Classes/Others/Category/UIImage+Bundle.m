//
//  UIImage+Bundle.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)
+ (UIImage *)imageNamedInResourceBundle:(NSString *)name {
    return [UIImage imageNamed:[NSString stringWithFormat:@"Resource.bundle/%@",name]];
}
@end
