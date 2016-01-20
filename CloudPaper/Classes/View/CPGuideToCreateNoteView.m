//
//  CPGuideToCreateNoteView.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/20.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPGuideToCreateNoteView.h"
#import "UIImage+Phoenix.h"
#import "YYLabel.h"

@interface CPGuideToCreateNoteView ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) YYLabel *label;
@property (nonatomic, weak) YYLabel *label2;
@end

@implementation CPGuideToCreateNoteView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamedInResourceBundle:@"note_empty"];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        YYLabel *label = [[YYLabel alloc] init];
        label.displaysAsynchronously = YES;
        label.text = @"便签为空";
        [self addSubview:label];
        self.label = label;
        
        YYLabel *label2 = [[YYLabel alloc] init];
        label2.displaysAsynchronously = YES;
        label2.text = @"点击右上角按钮新建便签";
        [self addSubview:label2];
        self.label2 = label2;
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat imageViewW = 100;
    CGFloat imageViewH = 105.7;
    CGFloat imageViewX = 20;
    CGFloat imageViewY = 0;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    self.imageView.backgroundColor = [UIColor grayColor];
    
    CGFloat labelX = 30;
    CGFloat labelY = CGRectGetMaxY(self.imageView.frame) + 30;
    CGFloat labelW = 80;
    CGFloat labelH = 40;
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    self.label.backgroundColor = [UIColor redColor];
    
    CGFloat label2X = 30;
    CGFloat label2Y = CGRectGetMaxY(self.label.frame) + 20;
    CGFloat label2W = 120;
    CGFloat label2H = 40;
    self.label2.frame = CGRectMake(label2X, label2Y, label2W, label2H);
    self.label2.backgroundColor = [UIColor yellowColor];
}

@end
