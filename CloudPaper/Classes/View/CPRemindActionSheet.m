//
//  CPRemindActionSheet.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/23.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPRemindActionSheet.h"
#import "CPNote.h"
#import "CPMacro.h"
#import "UIImage+Phoenix.h"
#import "Masonry.h"
#import "NSDate+CP.h"

// 按钮高度
#define BUTTON_H 49.0f


@interface CPRemindActionSheet ()
{
    CPNote *_note;
    NSDate *_tempDate;
    /** 暗黑色的view */
    UIView *_darkView;
    
    /** 所有按钮的底部view */
    UIView *_bottomView;
    
    UILabel *_remindDateLabel;
    
    
    UIDatePicker *_datePicker;
    
    UIButton *_saveOrEditButton;
    UIButton *_cancelButton;
    UIButton *_deleteButton;
    
    
    BOOL _appear;
    
    
}

@property (nonatomic, strong) UIWindow *backWindow;


@end

@implementation CPRemindActionSheet


- (instancetype)initWithNote:(CPNote *)note {
    self = [super init];
    if (self) {
        _tempDate = note.remindDate;
        _note = note;

        [self setupSuviews];
    }
    return self;
}

- (void)setupSuviews {
    // 暗黑色的view
    _darkView = [[UIView alloc] init];
    _darkView.alpha = 0;
    _darkView.userInteractionEnabled = NO;
    _darkView.backgroundColor = CPColor(46, 49, 50);
    [self addSubview:_darkView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [_darkView addGestureRecognizer:tap];
    
    // 所有按钮的底部view
    _bottomView= [[UIView alloc] init];
    _bottomView.backgroundColor = CPColor(233, 233, 238);
    [self addSubview:_bottomView];


    // 标题
    _remindDateLabel = [[UILabel alloc] init];
    _remindDateLabel.text = @"添加提醒";
    _remindDateLabel.textColor = CPColor(111, 111, 111);
    _remindDateLabel.backgroundColor = [UIColor whiteColor];
    _remindDateLabel.textAlignment = NSTextAlignmentCenter;
    _remindDateLabel.font = [UIFont fontWithName:@"Futura-Medium" size:17];
    [_bottomView addSubview:_remindDateLabel];

    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_bottomView addSubview:_datePicker];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    

    
    _deleteButton = [[UIButton alloc] init];
    [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_deleteButton setBackgroundImage:[UIImage resizedImageNamed:@"white"] forState:UIControlStateNormal];
    [_deleteButton setBackgroundImage:[UIImage resizedImageNamed:@"white"] forState:UIControlStateDisabled];
    
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitle:@"删除" forState:UIControlStateHighlighted];
    [_deleteButton setTitle:@"删除" forState:UIControlStateDisabled];
    
    [_bottomView addSubview:_deleteButton];
    [_deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    
    _saveOrEditButton = [[UIButton alloc] init];
    [_saveOrEditButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_saveOrEditButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_saveOrEditButton setBackgroundImage:[UIImage resizedImageNamed:@"white"] forState:UIControlStateNormal];
    [_saveOrEditButton setBackgroundImage:[UIImage resizedImageNamed:@"white"] forState:UIControlStateDisabled];
    
    [_saveOrEditButton setTitle:@"存储" forState:UIControlStateNormal];
    [_saveOrEditButton setTitle:@"存储" forState:UIControlStateHighlighted];
    [_saveOrEditButton setTitle:@"存储" forState:UIControlStateDisabled];
    [_bottomView addSubview:_saveOrEditButton];
    
    
    
    // 取消按钮
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setBackgroundImage:[UIImage resizedImageNamed:@"white"] forState:UIControlStateNormal];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [[_cancelButton titleLabel] setFont:[UIFont systemFontOfSize:16.0f]];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
    [_bottomView addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
 
    [self.backWindow addSubview:self];
    
    
    _appear = NO;
    
    
    if (_note.remindDate) {
//        _datePicker.hidden = YES;
//        _datePicker.enabled = NO;
        [_saveOrEditButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_saveOrEditButton setTitle:@"编辑" forState:UIControlStateHighlighted];
        [_saveOrEditButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    } else {
        _saveOrEditButton.enabled = NO;
        _deleteButton.enabled = NO;
        [_saveOrEditButton setTitle:@"存储" forState:UIControlStateNormal];
        [_saveOrEditButton setTitle:@"存储" forState:UIControlStateHighlighted];
        [_saveOrEditButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    if (!_note.remindDate) {
        _remindDateLabel.text = @"滑动添加提醒时间";
    } else if ([_note.remindDate timeIntervalSinceNow] < 0) {
        _remindDateLabel.text = @"闹钟提醒已过期";
    } else {
        _remindDateLabel.text = [NSDate showRemindDate:_note.remindDate];
    }


}

- (void)dateChanged:(UIDatePicker *)datepicker {
    if ([_saveOrEditButton.currentTitle isEqualToString:@"存储"]) {
        _saveOrEditButton.enabled = YES;
        _note.remindDate = _datePicker.date;
        _remindDateLabel.text = [NSDate showRemindDate:_datePicker.date];
    }
}

- (void)save {
    
    if ([self.delegate respondsToSelector:@selector(remindActionSheet:didSaveNote:)]) {
        [self.delegate remindActionSheet:self didSaveNote:_note];
    }
    
    [self close];
}

- (void)edit {
//    _datePicker.hidden = NO;
//    _datePicker.enabled = YES;
    [_saveOrEditButton setTitle:@"存储" forState:UIControlStateNormal];
    [_saveOrEditButton setTitle:@"存储" forState:UIControlStateHighlighted];
    [_saveOrEditButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
}

- (void)delete {
    if ([self.delegate respondsToSelector:@selector(remindActionSheet:didSaveNote:)]) {
        _note.remindDate = nil;
        [self.delegate remindActionSheet:self didSaveNote:_note];
    }
    [self close];
}

- (void)cancel {
    
    if (!_tempDate) {
        
        [self delete];
    }
    [self close];
}


+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}


- (void)updateConstraints {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.backWindow);
    }];
    
    [_darkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@290);
        
        if (_appear) {
            make.bottom.equalTo(self.mas_bottom);
        } else {
            make.top.equalTo(self.mas_bottom);
        }
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(_bottomView);
        make.height.equalTo(@50);
    }];
    
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottomView);
        make.bottom.equalTo(_cancelButton.mas_top).offset(-4);
        make.height.equalTo(@196);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_bottomView);
        make.bottom.equalTo(_datePicker.mas_top);
        make.width.equalTo(@50);
    }];
    
    [_saveOrEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(_bottomView);
        make.bottom.equalTo(_datePicker.mas_top);
        make.width.equalTo(@50);
    }];
    
    [_remindDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top);
        make.bottom.equalTo(_datePicker.mas_top);
        make.left.equalTo(_deleteButton.mas_right);
        make.right.equalTo(_saveOrEditButton.mas_left);
    }];
//    [self setNeedsUpdateConstraints];

    [super updateConstraints];
}

- (UIWindow *)backWindow {
    
    if (_backWindow == nil) {
        
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel       = UIWindowLevelStatusBar;
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    
    return _backWindow;
}



- (void)dismiss:(UITapGestureRecognizer *)tap {
    [self close];
}

- (void)close {
    _appear = !_appear;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         
                         [self layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         _backWindow.hidden = YES;
                         
                         [self removeFromSuperview];
                     }];
}


- (void)show {
    _appear = !_appear;
    _backWindow.hidden = NO;
    [_darkView setAlpha:0.4f];
    [_darkView setUserInteractionEnabled:YES];
    [self updateConstraintsIfNeeded];
    
//    [UIView animateWithDuration:0.3f
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         
//                         [_darkView setAlpha:0.4f];
//                         [_darkView setUserInteractionEnabled:YES];
//                         
//                         
//                         [self layoutIfNeeded];
//                     }
//                     completion:nil];
    

}

@end