//
//  CPNoteCell.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/20.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNoteCell.h"
#import "UIImage+Phoenix.h"
#import "CPMacro.h"

@interface CPNoteCell()
{
    UIImageView *_backgroundView;
    UIImageView *_selectedBackgroundView;
    UIView *_separatLine;
}
@end

@implementation CPNoteCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1.创建cell
    static NSString *noteCellID = @"cell";
    CPNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:noteCellID];
    if (cell == nil) {
        cell = [[CPNoteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:noteCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置笔记的内部子控件
        [self setupNoteSubViews];

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// 设置原创微博的内部子控件
- (void)setupNoteSubViews {
    // 设置cell选中时图片
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.image = [UIImage resizedImageNamed:@"cell_background_os9"];
    self.backgroundView = _backgroundView;
    
    _selectedBackgroundView = [[UIImageView alloc] init];
    _selectedBackgroundView.image = [UIImage resizedImageNamed:@"cell_background_highlighted_os9"];
    self.selectedBackgroundView = _selectedBackgroundView;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView  addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    _separatLine = [[UIView alloc] init];
    [self.contentView addSubview:_separatLine];
    
    UILabel *noteContentLabel = [[UILabel alloc] init];
    [self.contentView  addSubview:noteContentLabel];
    self.noteContentLabel = noteContentLabel;
    
    UILabel *remindLabel = [[UILabel alloc] init];
    [self.contentView  addSubview:remindLabel];
    self.remindLabel = remindLabel;
    
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = [UIImage imageNamedInResourceBundle:@"icon_photo"];
    [self.contentView  addSubview:photoView];
    self.photoView = photoView;
    
}


- (void)layoutSubviews {
    CGFloat cellWidth = SCREEN_WIDTH - 2 * CPNOTECELL_BORDER;
    CGFloat cellHeight = CPNOTECELL_HEIGHT - CPNOTECELL_BORDER;

    _backgroundView.frame = self.contentView.bounds;
    _selectedBackgroundView.frame = self.contentView.bounds;
    
    CGFloat timeLabelX = 2 * CPNOTECELL_BORDER;
    CGFloat timeLabelW = 150;
    CGFloat timeLabelH = 25;
    self.timeLabel.frame = CGRectMake(timeLabelX, 0, timeLabelW, timeLabelH);
//    self.timeLabel.backgroundColor = [UIColor yellowColor];
    
    CGFloat separateLineY = timeLabelH;
    CGFloat separateLineW = cellWidth;
    CGFloat separateLineH = 1;
    _separatLine.frame = CGRectMake(1.5, separateLineY, separateLineW - 3, separateLineH);
    _separatLine.backgroundColor = CPColor(226, 226, 226);
    _separatLine.alpha = 0.7;
    
    CGFloat remindLabelW = 70;
    CGFloat remindLabelH = timeLabelH;
    CGFloat remindLabelX = cellWidth - remindLabelW;
    self.remindLabel.frame = CGRectMake(remindLabelX, 0, remindLabelW, remindLabelH);
//    self.remindLabel.backgroundColor = [UIColor purpleColor];
    
    CGFloat photoViewW = 40;
    CGFloat photoViewH = 28;
    CGFloat photoViewX = cellWidth - photoViewW;
    CGFloat photoViewY = remindLabelH + 7;
    self.photoView.frame = CGRectMake(photoViewX, photoViewY, photoViewW, photoViewH);
//    self.photoView.backgroundColor = [UIColor greenColor];
    
    CGFloat noteContentLabelY = timeLabelH;
    CGFloat noteContentLabelW = cellWidth - photoViewW - timeLabelX;
    CGFloat noteContentLabelH = cellHeight - timeLabelH;
    self.noteContentLabel.frame = CGRectMake(timeLabelX, noteContentLabelY, noteContentLabelW, noteContentLabelH);
//    self.noteContentLabel.backgroundColor = [UIColor orangeColor];
    
    
}

/**
 *  拦截frame的设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += CPNOTECELL_BORDER;
    frame.origin.x = CPNOTECELL_BORDER;
    frame.size.width -= 2 * CPNOTECELL_BORDER;
    frame.size.height -= CPNOTECELL_BORDER;
    [super setFrame:frame];
}

@end
