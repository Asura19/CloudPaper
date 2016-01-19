//
//  UIBarButtonItem+CP.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "UIBarButtonItem+CP.h"
#import "UIImage+Bundle.h"

@implementation UIBarButtonItem (CP)
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon
                  highligntedIcon:(NSString *)highligntedIcon
                           target:(id)target
                           action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamedInResourceBundle:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamedInResourceBundle:highligntedIcon] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, button.currentImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
