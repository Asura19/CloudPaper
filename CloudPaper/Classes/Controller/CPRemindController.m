//
//  CPRemindController.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/22.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPRemindController.h"
#import "CPMacro.h"
#import "UIBarButtonItem+CP.h"
#import "Masonry.h"
#import "UIImage+Phoenix.h"
#import "CPNote.h"
#import "NSDate+CP.h"
#import "CPNoteManager.h"

@interface CPRemindController ()
{
    CPNote *_note;
    UIDatePicker *_datePicker;
    UILabel *_remindDateLabel;
    UIButton *_deleteButton;
    UIBarButtonItem *_saveItem;
    UIBarButtonItem *_cancel;
    UIBarButtonItem *_editItem;
}

@end

@implementation CPRemindController

- (instancetype)initWithNote:(CPNote *)note {
    self = [super init];
    if (self) {
        _note = note;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationItems];
    [self initSubViews];
    
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (_note.remindDate) {
        _datePicker.hidden = YES;
        self.navigationItem.rightBarButtonItem = _editItem;
    } else {
        _saveItem.enabled = NO;
        _deleteButton.enabled = NO;
        self.navigationItem.rightBarButtonItem = _saveItem;
    }
    
}

- (void)setupNavigationItems {
    // setup navigationbar title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:NAVIGATIONBAR_SETTING_TITLE_FONT_SIZE];
    titleLabel.text = @"添加提醒";
    titleLabel.textColor = [UIColor whiteColor];
    CGSize titleLabelSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:NAVIGATIONBAR_SETTING_TITLE_FONT}];
    titleLabel.frame = (CGRect){{0, 0}, titleLabelSize};
    self.navigationItem.titleView = titleLabel;
    // setup navigationbar right item
    _saveItem = [[UIBarButtonItem alloc] initWithTitle:@"存储" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    _editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}



- (void)initSubViews {
    
    _remindDateLabel = [[UILabel alloc] init];
    _remindDateLabel.font = [UIFont systemFontOfSize:19];
    _remindDateLabel.textAlignment = NSTextAlignmentCenter;
    
    
    if (!_note.remindDate) {
        _remindDateLabel.text = @"滑动添加提醒时间";
    } else if ([_note.remindDate timeIntervalSinceNow] < 0) {
        _remindDateLabel.text = @"闹钟提醒已过期";
    } else {
        _remindDateLabel.text = [NSDate showRemindDate:_note.remindDate];
    }
    
    _remindDateLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_remindDateLabel];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.view addSubview:_datePicker];
    
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    _deleteButton = [[UIButton alloc] init];
    [_deleteButton setBackgroundImage:[UIImage resizedImageNamed:@"delete_warning"] forState:UIControlStateNormal];
    [_deleteButton setBackgroundImage:[UIImage resizedImageNamed:@"delete_warning_highlighted"] forState:UIControlStateHighlighted];
    [_deleteButton setBackgroundImage:[UIImage resizedImageNamed:@"delete_warning_disable"] forState:UIControlStateDisabled];
    [_deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *deleteLabel = [[UILabel alloc] init];
    deleteLabel.font = [UIFont systemFontOfSize:20];
    deleteLabel.text = @"删     除";
    deleteLabel.textColor = [UIColor whiteColor];

    CGSize deleteLabelSize = [deleteLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    [_deleteButton addSubview:deleteLabel];
    [self.view addSubview:_deleteButton];
    
    [_remindDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@280);
        make.height.equalTo(@50);
    }];
    
    
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_remindDateLabel.mas_bottom).offset(50);
        make.height.equalTo(@200);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_datePicker.mas_bottom).offset(80);
        make.width.equalTo(@300);
        make.height.equalTo(@50);
    }];
    
    
    [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_deleteButton.mas_centerX);
        make.centerY.equalTo(_deleteButton.mas_centerY);
        make.width.equalTo(@(deleteLabelSize.width));
        make.height.equalTo(@(deleteLabelSize.height));
    }];
}


- (void)dateChanged:(UIDatePicker *)datepicker {
    _saveItem.enabled = YES;
    _note.remindDate = _datePicker.date;
    _remindDateLabel.text = [NSDate showRemindDate:_datePicker.date];
}



- (void)save {
    
    if ([self.delegate respondsToSelector:@selector(remindViewController:didSaveNote:)]) {
        [self.delegate remindViewController:self didSaveNote:_note];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)edit {
    _datePicker.hidden = NO;
    self.navigationItem.rightBarButtonItem = _saveItem;
}

- (void)delete {
    if ([self.delegate respondsToSelector:@selector(remindViewController:didSaveNote:)]) {
        _note.remindDate = nil;
        [self.delegate remindViewController:self didSaveNote:_note];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
