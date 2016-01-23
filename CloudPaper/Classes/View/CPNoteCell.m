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
#import "NSDate+CP.h"

@interface CPNoteCell()
{
    UIImageView *_backgroundView;
    UIView *_myContentView;
    UIImageView *_selectedBackgroundView;
    UIView *_separatLine;
//    UIButton *_deleteButton;
//    UIButton *_remindButton;
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
//        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//        [gesture setMaximumNumberOfTouches:1];
//        [self addGestureRecognizer:gesture];
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = CPColor(115, 194, 247);
    }
    return self;
}

//- (void)panGesture:(UIPanGestureRecognizer *)gesture {
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:
//            NSLog(@"begin");
//            break;
//        case UIGestureRecognizerStateChanged:
//            [self.contentView setFrame:CGRectMake([gesture translationInView:self].x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//            [self.backgroundView setFrame:CGRectMake([gesture translationInView:self].x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//
//            break;
//        case UIGestureRecognizerStateEnded:
//        {
//            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                [self.contentView setFrame:CGRectMake(0, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//                [self.backgroundView setFrame:CGRectMake(0, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//
//            } completion:nil];
//        }
//        break;
//        default:
//            break;
//    }
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ([gestureRecognizer.view isKindOfClass:[UITableView class]]) {
//        return YES;
//    }
//    return NO;
//
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([gestureRecognizer.view isKindOfClass:[UITableView class]]) {
//        return YES;
//    }
//    return YES;
//}


// 设置cell的内部子控件
- (void)setupNoteSubViews {
    // 设置cell选中时图片
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.image = [UIImage resizedImageNamed:@"cell_background_os9"];
    self.backgroundView = _backgroundView;
    
    _selectedBackgroundView = [[UIImageView alloc] init];
    _selectedBackgroundView.image = [UIImage resizedImageNamed:@"cell_background_highlighted_os9"];
    self.selectedBackgroundView = _selectedBackgroundView;
    
//    _deleteButton = [[UIButton alloc] init];
////    _deleteButton.backgroundColor = [UIColor redColor];
//    [self addSubview:_deleteButton];
//    [self insertSubview:_deleteButton belowSubview:self.backgroundView];
//    _remindButton = [[UIButton alloc] init];
////    _remindButton.backgroundColor = [UIColor redColor];
//    [self addSubview:_remindButton];
//    [self insertSubview:_remindButton belowSubview:self.backgroundView];

    _myContentView = [UIView new];
    [_myContentView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_myContentView];
    
    YYLabel *timeLabel = [[YYLabel alloc] init];
    [self.myContentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    _separatLine = [[UIView alloc] init];
    [self.myContentView addSubview:_separatLine];
    
    YYLabel *noteContentLabel = [[YYLabel alloc] init];
    [self.myContentView  addSubview:noteContentLabel];
    self.noteContentLabel = noteContentLabel;
    
    UIImageView *remindView = [[UIImageView alloc] init];
    [self.myContentView  addSubview:remindView];
    self.remindView = remindView;
    
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = [UIImage imageNamedInResourceBundle:@"icon_photo"];
    [self.myContentView  addSubview:photoView];
    self.photoView = photoView;
    
}


- (void)layoutSubviews {
    CGFloat cellWidth = SCREEN_WIDTH - 3;
    CGFloat cellHeight = CPNOTECELL_HEIGHT - CPNOTECELL_BORDER;
    [self.contentView setFrame:self.bounds];
    [self.myContentView setFrame:CGRectMake(2, 2, self.contentView.bounds.size.width - 4, self.contentView.bounds.size.height - 4)];
    _backgroundView.frame = self.contentView.bounds;
    _selectedBackgroundView.frame = self.contentView.bounds;
    
//    _deleteButton.frame = CGRectMake(0, 0, 30, 30);
//    _remindButton.frame = CGRectMake(350, 0, 30, 30);
//
    CGFloat timeLabelX = 2 * CPNOTECELL_BORDER;
    CGFloat timeLabelW = 150;
    CGFloat timeLabelH = 25;
    self.timeLabel.frame = CGRectMake(timeLabelX, 2, timeLabelW, timeLabelH);
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = CPColor(111, 111, 111);
    
    CGFloat separateLineY = timeLabelH + 1;
    CGFloat separateLineW = cellWidth;
    CGFloat separateLineH = 2 / [UIScreen mainScreen].scale;
    _separatLine.frame = CGRectMake(0, separateLineY, separateLineW, separateLineH);
    _separatLine.backgroundColor = CPColor(226, 226, 226);
    _separatLine.alpha = 0.7;
    
    CGFloat remindViewW = 20;
    CGFloat remindViewH = remindViewW;
    CGFloat remindViewX = cellWidth - remindViewW - 10;
    CGFloat remindViewY = 2;
    self.remindView.frame = CGRectMake(remindViewX, remindViewY, remindViewW, remindViewH);

    
    CGFloat photoViewW = 40;
    CGFloat photoViewH = 28;
    CGFloat photoViewX = cellWidth - photoViewW;
    CGFloat photoViewY = remindViewH + 15;
    self.photoView.frame = CGRectMake(photoViewX, photoViewY, photoViewW, photoViewH);
    
    CGFloat noteContentLabelY = timeLabelH;
    CGFloat noteContentLabelW = cellWidth - photoViewW - timeLabelX;
    CGFloat noteContentLabelH = cellHeight - timeLabelH;
    self.noteContentLabel.frame = CGRectMake(timeLabelX, noteContentLabelY, noteContentLabelW, noteContentLabelH);
    self.noteContentLabel.font = [UIFont systemFontOfSize:19];
}

- (void)setNote:(CPNote *)note {
    _note = note;
    NSString *content = _note.content;
    if ([content length] > 40) {
        self.noteContentLabel.text = [content substringWithRange:NSMakeRange(0, 40)];
    } else {
        self.noteContentLabel.text = content;
    }
    
    self.timeLabel.text = [NSDate showDate:note.updatedDate];
    
    if (_note.remindDate) {
        self.remindView.image = [UIImage imageNamedInResourceBundle:@"clock"];
    }
}
@end
