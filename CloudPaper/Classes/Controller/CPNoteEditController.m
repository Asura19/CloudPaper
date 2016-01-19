//
//  CPNoteEditController.m
//  CloudPaper
//
//  Created by Phoenix on 16/1/18.
//  Copyright © 2016年 Phoenix. All rights reserved.
//

#import "CPNoteEditController.h"
#import "CPNote.h"
#import "Masonry.h"
#import "ProgressHUD.h"
#import "CPMacro.h"
#import "YYText.h"
#import "UIBarButtonItem+CP.h"

CGFloat const kHorizontalMargin = 10.f;
CGFloat const kVerticalMargin = 10.f;

@interface CPNoteEditController ()<YYTextViewDelegate>
{
    CPNote *_note;
    YYTextView *_contentTextView;
    BOOL _saved;
    UIBarButtonItem *_doneItem;
    UIBarButtonItem *_addPhotoItem;
    UIBarButtonItem *_deleteItem;
    UIBarButtonItem *_shareItem;
}
@end

@implementation CPNoteEditController

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
    _saved = NO;
    // 右划返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self ceateNavigationBarItem];
    [self initSuiews];
    // 监听键盘状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)ceateNavigationBarItem
{
    // 创建导航栏Item
    _doneItem = [UIBarButtonItem itemWithIcon:@"btn_done"
                              highligntedIcon:@"nothing"
                                       target:self
                                       action:@selector(save)];
    
    _addPhotoItem = [UIBarButtonItem itemWithIcon:@"btn_camera"
                                  highligntedIcon:@"nothing"
                                           target:self
                                           action:@selector(addPhoto)];
    
    _shareItem = [UIBarButtonItem itemWithIcon:@"btn_send"
                               highligntedIcon:@"nothing"
                                        target:self
                                        action:@selector(share)];
    
    _deleteItem = [UIBarButtonItem itemWithIcon:@"btn_delete"
                                highligntedIcon:@"nothing"
                                         target:self
                                         action:@selector(delete)];
}

- (void)initSuiews
{
    CGRect frame = self.view.bounds;
    _contentTextView = [[YYTextView alloc] initWithFrame:frame];

    _contentTextView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 10);
    _contentTextView.delegate = self;
//    _contentTextView.backgroundColor = [UIColor grayColor];
    _contentTextView.textColor = [UIColor blackColor];
    _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_contentTextView setScrollEnabled:YES];

    if (_note) {
        [self setupAttributedText:_note.content];
        [self turnToLookingUpState];
    } else {
        [self setupAttributedText:@""];
        [self turnToEditingState];
        [_contentTextView becomeFirstResponder];
    }
    [self.view addSubview:_contentTextView];
}

- (void)turnToEditingState {
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_doneItem, _addPhotoItem, nil];
}

- (void)turnToLookingUpState {
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_shareItem, _deleteItem, nil];
}

- (void)setupAttributedText:(NSString *)string {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = [UIFont fontWithName:@"Times New Roman" size:19];
//    text.yy_lineSpacing = 1;
    text.yy_firstLineHeadIndent = 0;
    _contentTextView.attributedText = text;
    [_contentTextView setFont:[UIFont fontWithName:@"Times New Roman" size:19]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!_saved) {
        [self save];
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self turnToEditingState];
//    _isEditingContent = YES;
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
         CGFloat keyboardHeight = keyboardFrame.size.height;
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - keyboardHeight;
         _contentTextView.frame = frame;
     }               completion:NULL];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    _isEditingContent = NO;
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         
         _contentTextView.frame = self.view.frame;
     }               completion:nil];
}

- (void)hideKeyboard
{
    if ([_contentTextView isFirstResponder]) {
//        _isEditingContent = NO;
        [_contentTextView resignFirstResponder];
    }
}

#pragma mark - Save

- (void)save
{
    [self hideKeyboard];
    NSString *string = (NSString *)_contentTextView.text;
    
    if ([string isEqualToString:@" "]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    string = [string stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ((string == nil || string.length == 0)) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSDate *createDate;
    if (_note && _note.createdDate) {
        createDate = _note.createdDate;
    } else {
        createDate = [NSDate date];
    }
    
    CPNote *note = [[CPNote alloc] initWithTitle:nil
                                         content:string
                                     createdDate:createDate
                                      updateDate:[NSDate date]];
    _note = note;
    BOOL success = [note Persistence];
    if (success) {
        _saved = YES;
        [self turnToLookingUpState];
    } else {
        [ProgressHUD showError:@"SaveFail"];
    }
}

- (void)addPhoto {
    
}

- (void)share {
    
}

- (void)delete {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textViewDidChange:(YYTextView *)textView {
    // 监听字数
}

@end
