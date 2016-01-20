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
#import "CPMacro.h"

#define LABEL_FONT [UIFont systemFontOfSize:19]
#define LABEL2_FONT [UIFont systemFontOfSize:11]

@interface CPGuideToCreateNoteView ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) YYLabel *label;
@property (nonatomic, weak) YYLabel *label2;
@end

@implementation CPGuideToCreateNoteView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor magentaColor];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamedInResourceBundle:@"note_empty"];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        YYLabel *label = [[YYLabel alloc] init];
//        label.displaysAsynchronously = YES;
        label.text = @"便签为空";
        [self addSubview:label];
        self.label = label;
        
        YYLabel *label2 = [[YYLabel alloc] init];
//        label2.displaysAsynchronously = YES;
        label2.text = @"点击右上角按钮新建便签";
        [self addSubview:label2];
        self.label2 = label2;
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat imageViewW = 100;
    CGFloat imageViewH = 105.7;
    CGFloat imageViewX = (self.frame.size.width - imageViewW) * 0.5;
    CGFloat imageViewY = 0;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    
    self.label.font = LABEL_FONT;
    self.label.textColor = CPColor(222, 213, 206);
    CGFloat labelX = 30;
    CGFloat labelY = imageViewH + 2;
    CGSize labelSize = [@"便签为空" sizeWithAttributes:@{NSFontAttributeName:LABEL_FONT}];
    self.label.frame = (CGRect){{labelX, labelY}, labelSize};
    [self.label setCenter:CGPointMake(self.imageView.center.x, self.label.center.y)];
    
    self.label2.font = LABEL2_FONT;
    self.label2.textColor = CPColor(222, 213, 206);
    CGFloat label2X = 0;
    CGFloat label2Y = CGRectGetMaxY(self.label.frame) + 5;
    CGSize label2Size = [self.label2.text sizeWithAttributes:@{NSFontAttributeName:LABEL2_FONT}];
    self.label2.frame = (CGRect){{label2X, label2Y}, label2Size};
    [self.label2 setCenter:CGPointMake(self.imageView.center.x, self.label2.center.y)];
}

@end
