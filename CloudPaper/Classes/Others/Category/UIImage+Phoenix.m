//
//  UIImage+Phoenix.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/20.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "UIImage+Phoenix.h"

@implementation UIImage (Phoenix)

+ (UIImage *)resizedImageNamed:(NSString *)name
{
    return [self resizedImageNamed:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageNamed:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [UIImage imageNamedInResourceBundle:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

+ (UIImage *)imageNamedInResourceBundle:(NSString *)name {
    return [UIImage imageNamed:[NSString stringWithFormat:@"Resource.bundle/%@",name]];
}
@end
