//
//  CPMacro.h
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#ifndef CPMacro_h
#define CPMacro_h
#endif /* CPMacro_h */

//#import "CPConstants.h"

/**
 *  获得RGB颜色
 */
#define CPColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
/**
 *  导航栏颜色
 */
#define NAVIGATIONBAR_COLOR CPColor(72, 169, 245)
/**
 *  导航栏标题字体
 */
#define NAVIGATIONBAR_TITLE_FONT_SIZE 21
#define NAVIGATIONBAR_TITLE_FONT [UIFont systemFontOfSize:NAVIGATIONBAR_TITLE_FONT_SIZE]
/**
 *  导航栏“设置”字体
 */
#define NAVIGATIONBAR_SETTING_TITLE_FONT_SIZE 19
#define NAVIGATIONBAR_SETTING_TITLE_FONT [UIFont systemFontOfSize:19]
/**
 *  自定义cell参数
 */
#define CPNOTECELL_BORDER 8
#define CPNOTECELL_HEIGHT 80
/**
 *  屏幕宽高
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
/**
 *  编辑界面计数数字的字体
 */
#define NAVIGATIONBAR_COUNT_FONT_SIZE 16
#define NAVIGATIONBAR_COUNT_FONT [UIFont systemFontOfSize:16]

#define SaveNoteWhenApplicationEnterBackground @"SaveNoteWhenApplicationEnterBackground" 