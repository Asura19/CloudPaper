//
//  CPSearchBar.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/21.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPSearchBar.h"
#import "UIImage+Phoenix.h"

@implementation CPSearchBar
+ (CPSearchBar *)searchBar {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.background = [UIImage resizedImageNamed:@"searchbar_textfield_background_os7"];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamedInResourceBundle:@"searchbar_textfield_search_icon"]];
        iconView.contentMode = UIViewContentModeCenter;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = iconView;
        self.leftView.frame = CGRectMake(0, 0, 30, self.frame.size.height);

        self.font = [UIFont systemFontOfSize:14];
        
//        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:attrs];
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

@end
